#coding=utf-8
class BriefItemsController < ApplicationController
  before_filter :cur_user 

  def edit
    @item = BriefItem.find(params[:id])
    invalid_op unless @item.op_right.check('self',@cur_user.org_id,'update')
    @brief = @item.brief
  end

  def update
    @item = BriefItem.find(params[:id])
    invalid_op unless @item.op_right.check('self',@cur_user.org_id,'update')
    @brief = @item.brief
    
    notice_ids = @item.op_notice.changed_by(@cur_user.org_id)

    attr = params[:brief_item]
    @item.name = attr[:name]
    @item.quantity = attr[:quantity]
    @item.note = attr[:note]
    @item.kind = attr[:kind]

    if @item.save
      @brief.op_notice.add(notice_ids)
      @brief.save
      redirect_to brief_path(@brief), notice: 'Item was successfully updated.'  
    else
      render :action => :edit
    end
  end

  def destroy
    item = BriefItem.find(params[:id])
    brief = item.brief
    invalid_op unless item.op_right.check('self',@cur_user.org_id,'delete')

    notice_ids = item.op_right.who_has('self','read') - [@cur_user.org_id]
    item.destroy

    brief.op_notice.add(notice_ids)
    brief.save

    redirect_to brief_path(brief)  
  end

  #brief_items/new/many?brief_id=1&kind=design         new many items for a brief
  def new_many
    @brief = Brief.find(params[:brief_id]) 
    @kind_default = params[:kind]
    @brief_item = {}
    @item_count = 5
  end

  def create_many
    @brief = Brief.find(params[:brief_id]) 

    case
    when params[:save_many]
      invalid_op unless @brief.op_right.check('item',@cur_user.org_id,'update')
      org_ids = @brief.op_right.who_has('item','update')
      notice_org_ids = org_ids - [@cur_user.org_id]

      n = 0
      saved_count = 0
      attr = params[:brief_item]
      while attr["name_#{n}"]
        item = @brief.items.new
        item.name = attr["name_#{n}"]
        item.quantity = attr["quantity_#{n}"]
        item.note = attr["note_#{n}"]
        item.kind = attr["kind_#{n}"]
        
        item.op_right.add('self',org_ids,'read','update','delete')
        item.op_notice.add(notice_org_ids)

        if item.save
          saved_count += 1
        end
        n += 1
      end
      if saved_count > 0
        @brief.reload   #must reload,it should be a bug of activerecord.relative to brief.items.new? 
        @brief.op_notice.add(notice_org_ids)
        @brief.save
      end
      redirect_to brief_path(params[:brief_id])
    when (params[:add_5_design] or params[:add_5_product])
      @kind_default = ['design','product'].find{|e| params["add_5_#{e}"]} #add 5 design or product
      n = 0
      @brief_item = params["brief_item"]
      n += 1 while @brief_item["name_#{n}"]
      
      @item_count = n+5
      render :action=>:new_many 
    end
  end

  def edit_many
    @brief = Brief.find(params[:brief_id]) 
    invalid_op unless @brief.op_right.check('item',@cur_user.org_id,'update')

    items = @brief.items
    designs = []
    products = []
    items.each do |e|
      case e.kind
      when 'design' then designs << e
      when 'product' then products << e
      end
    end

    @items = designs + products
  end

  def update_many
    brief = Brief.find(params[:brief_id]) 
    invalid_op unless brief.op_right.check('item',@cur_user.org_id,'update')
    items = params[:brief_item]

    ids = []
    items.keys.each{|e| ids << $1 if e =~ /name_(\d+)/}

    updated_count = 0
    brief_notice_ids = []

    ids.each do |id|
      if item = brief.items.where(:id=>id).first
        item.name = items["name_#{id}"]
        item.quantity = items["quantity_#{id}"]
        item.note = items["note_#{id}"]
        item.kind = items["kind_#{id}"]
        
        item_notice_ids = item.op_notice.changed_by(@cur_user.org_id)

        brief_notice_ids += item_notice_ids - brief_notice_ids
        if item.save
          updated_count += 1
        end
      end
    end

    if updated_count > 0
      brief.op_notice.add(brief_notice_ids)
      brief.save
    end

    redirect_to brief_path(params[:brief_id])
  end
end


