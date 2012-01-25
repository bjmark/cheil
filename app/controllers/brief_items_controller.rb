#coding=utf-8
class BriefItemsController < ApplicationController
  before_filter :cur_user 

  #brief_items/new?brief_id=1&kind=design      new a item for a brief
  def new
    @brief = Brief.find(params[:brief_id]) 
    @item = @brief.items.new
    @item.kind = params[:kind].blank? ? 'design' : params[:kind]
  end

  def edit
    @item = BriefItem.find(params[:id])
    @brief = @item.brief
    @brief.check_edit_right(@cur_user.org_id)     #check right
  end


  def set_attr(attr)
    @item.name = attr[:name]
    @item.quantity = attr[:quantity]
    @item.note = attr[:note]
    @item.kind = attr[:kind]
  end

  def create
    @brief = Brief.find(params[:brief_id]) 
    @brief.check_edit_right(@cur_user.org_id)     #check right
    @item = @brief.items.new

    set_attr(params[:brief_item])

    if @item.op.save_by(@cur_user.id)
      @brief.op.touch(@cur_user.id)
      redirect_to brief_path(@brief), notice: 'Item was successfully created.'  
    else
      render :action => :new
    end
  end

  def update
    @item = BriefItem.find(params[:id])
    @brief = @item.brief
    @brief.check_edit_right(@cur_user.org_id)     #check right

    set_attr(params[:brief_item])

    if @item.op.save_by(@cur_user.id)
      @brief.op.touch(@cur_user.id)
      redirect_to brief_path(@brief), notice: 'Item was successfully updated.'  
    else
      render :action => :edit
    end
  end

  def destroy
    item = BriefItem.find(params[:id])
    brief = item.brief
    brief.check_edit_right(@cur_user.org_id)     #check right

    item.destroy
    brief.op.touch(@cur_user.id)
    redirect_to brief_path(brief)  
  end

  #brief_items/new/many?brief_id=1&kind=design         new many items for a brief
  def new_many
    @brief = Brief.find(params[:brief_id]) 
    @kind_default = params[:kind]
    @item_count = 5
  end

  def create_many
    @brief = Brief.find(params[:brief_id]) 
    @brief.check_edit_right(@cur_user.org_id)     #check right

    case
    when params[:save_many]
      n = 0
      saved_count = 0
      while params["name_#{n}"]
        attr = {}
        %w{name quantity note kind}.each {|e| attr[e] = params["#{e}_#{n}"]}
        item = @brief.items.new(attr)
        if item.op.save_by(@cur_user.id)
          saved_count += 1
        end
        n += 1
      end
      if saved_count > 0
        @brief.op.touch(@cur_user.id)
      end
      redirect_to brief_path(params[:brief_id])
    when (params[:add_5_design] or params[:add_5_product])
      @kind_default = ['design','product'].find{|e| params["add_5_#{e}"]} #add 5 design or product
      n = 0
      n += 1 while params["name_#{n}"]
      @item_count = n+5
      render :action=>:new_many 
    end
  end

  def edit_many
    @brief = Brief.find(params[:brief_id]) 
    @brief.check_edit_right(@cur_user.org_id)     #check right

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
    brief.check_edit_right(@cur_user.org_id)     #check right
    items = params[:brief_item]
    
    ids = []
    items.keys.each{|e| ids << $1 if e =~ /name_(\d+)/}
      
    updated_count = 0

    ids.each do |id|
      if item = brief.items.where(:id=>id).first
        item.name = items["name_#{id}"]
        item.quantity = items["quantity_#{id}"]
        item.note = items["note_#{id}"]
        item.kind = items["kind_#{id}"]
        if item.op.save_by(@cur_user.id)
          updated_count += 1
        end
      end
    end

    if updated_count > 0
      brief.op.touch(@cur_user.id)
    end

    redirect_to brief_path(params[:brief_id])
  end
end


