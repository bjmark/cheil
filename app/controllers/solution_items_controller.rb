#encoding=utf-8
class SolutionItemsController < ApplicationController
  before_filter :cur_user 

  def edit
    @item = SolutionItem.find(params[:id])
    invalid_op unless @item.op_right.check('self',@cur_user.org_id,'update')
    @solution = @item.solution
  end

  def update
    @item = Item.find(params[:id])
    invalid_op unless @item.op_right.check('self',@cur_user.org_id,'update')

    attr = params[:solution_item]

    @item.name = attr[:name]
    @item.quantity = attr[:quantity]
    @item.note = attr[:note]
    @item.price = attr[:price]
    @item.kind = attr[:kind]


    if @item.op.save_by(@cur_user.id)
      @item.solution.op.touch(@cur_user.id)
      redirect_to vendor_solution_path(@item.solution), notice: 'Item was successfully updated.' 
    else
      render action: "edit" 
    end
  end

  def edit_price
    @item = SolutionItem.find(params[:id])
    invalid_op unless @item.op_right.check('self',@cur_user.org_id,'price')
  end

  def update_price #tested
    @item = SolutionItem.find(params[:id])
    invalid_op unless @item.op_right.check('self',@cur_user.org_id,'price')

    attr = params[:solution_item]
    @item.note = attr[:note]
    @item.price = attr[:price]
    @item.tax_rate = attr[:tax_rate]
    
    notice_ids = @item.op_notice.changed_by(@cur_user.org_id)

    @item.cal_save

    solution = @item.solution
    solution.op_notice.add(notice_ids)
    solution.save

    brief = solution.brief
    brief.op_notice.add(notice_ids)
    brief.save

    redirect_to vendor_solution_path(solution)  
  end

  def edit_price_many #tested
    @solution = VendorSolution.find(params[:solution_id])
    invalid_op unless @solution.op_right.check('item',@cur_user.org_id,'price_design_product')

    items = @solution.items
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

  def update_price_many #tested
    solution = VendorSolution.find(params[:solution_id])
    invalid_op unless solution.op_right.check('item',@cur_user.org_id,'price_design_product')

    items = params[:solution_item]

    ids = []
    items.keys.each{|e| ids << $1 if e =~ /price_(\d+)/}

    brief = solution.brief

    ids.each do |id|
      if !(item = solution.items.where(:id=>id).first).blank?
        item.note = items["note_#{id}"]
        item.price = items["price_#{id}"]
        item.tax_rate = items["tax_rate_#{id}"]
        
        notice_ids = item.op_notice.changed_by(@cur_user.org_id)
        
        solution.op_notice.add(notice_ids)
        brief.op_notice.add(notice_ids)
        
        item.cal_save
      end
    end

    solution.save
    brief.save
    redirect_to vendor_solution_path(params[:solution_id])
  end

  def set_attr(attr)
    @item.name = attr[:name]
    @item.quantity = attr[:quantity]
    @item.note = attr[:note]
    @item.price = attr[:price]
    @item.kind = attr[:kind]
  end

=begin
  def create
    case
      #add a brief_item to vendor_solution
    when (params[:vendor_solution_id] and params[:brief_item_id])
      vendor_solution = VendorSolution.find(params[:vendor_solution_id])
      #raise SecurityError unless solution.brief.received_by?(@cur_user.org_id)
      invalid_op unless vendor_solution.op_right.check('item',@cur_user.org_id,'assign_brief_item')

      if vendor_solution.items.where(:parent_id=>params[:brief_item_id]).blank?
        brief_item = BriefItem.find(params[:brief_item_id])
        #brief_item.add_to_solution(vendor_solution)
        item = vendor_solution.items.new(:parent_id=>brief_item.id)
        item.op_right.add('self',@cur_user.org_id,'read','delete')
        item.op_right.add('self',vendor_solution.org_id,'read','price')

        #notify the vendor for this item
        item.op_notice.add(vendor_solution.org_id)
        item.save

        #the solution owner can read this brief_item
        brief_item.op_right.add('self',vendor_solution.org_id,'read')
        brief_item.save

        #notify the vendor for relate brief
        brief = vendor_solution.brief
        brief.op_notice.add(vendor_solution.org_id)
        brief.save
      end
      redirect_to(solution_items_path(:vendor_solution_id=>vendor_solution.id)) and return
    end

    #create a solution_item
    attr = params[:solution_item]
    solution = Solution.find(attr[:fk_id])
    solution.check_edit_right(@cur_user.org_id)

    @item = solution.items.new
    set_attr(attr)

    solution.op.touch(@cur_user.id)

    if @item.op.save_by(@cur_user.id)
      solution.op.touch(@cur_user.id)
      redirect_to vendor_solution_path(solution), notice: 'Item was successfully created.' 
    else
      render action: "new" 
    end
  end
=end

  def destroy #tested
    item = SolutionItem.find(params[:id])
    invalid_op unless item.op_right.check('self',@cur_user.org_id,'delete')
    
    notice_ids = item.op_notice.changed_by(@cur_user.org_id)
    item.destroy

    solution = item.solution
    solution.op_notice.add(notice_ids)
    solution.save

    brief = solution.brief
    brief.op_notice.add(notice_ids)
    brief.save

    redirect_to(vendor_solution_path(solution)) 
  end

  def check #test
    item = SolutionItem.find(params[:id])
    invalid_op unless item.op_right.check('self',@cur_user.org_id,'check')

    value = 'y'
    if block_given? 
      value = yield
    end
    item.checked = value
    notice_ids = item.op_notice.changed_by(@cur_user.org_id)
    item.save

    solution = item.solution
    solution.op_notice.add(notice_ids)
    solution.save

    brief = solution.brief
    brief.op_notice.add(notice_ids)
    brief.save

    if params[:dest]
      redirect_to params[:dest]
    else
      redirect_to vendor_solution_path(solution)
    end
  end

  def uncheck
    check{'n'}
  end

  def new_many
    @solution = VendorSolution.find(params[:solution_id]) 
    @kind_default = params[:kind]
    @item_count = 5
  end

  def create_many #tested
    @solution = VendorSolution.find(params[:solution_id]) 
    invalid_op unless @solution.op_right.check('item',@cur_user.org_id,'create_tran_other')

    case
    when params[:save_many]
      read_ids = @solution.op_right.who_has('item','read') - [@cur_user.org_id]

      n = -1 ; saved_count = 0
      while params["name_#{n+=1}"]
        next if params["name_#{n}"].blank?
        attr = {}
        %w{name quantity note price tax_rate kind}.each {|e| attr[e] = params["#{e}_#{n}"]}
        item = @solution.items.new(attr)

        item.op_right.add('self',@cur_user.org_id,'read','update','delete')

        item.op_right.add('self',read_ids ,'read')
        item.op_right.add('self',@solution.brief.cheil_id,'check')

        item.op_notice.add(read_ids)

        saved_count += 1 if item.cal_save
      end
      if saved_count > 0
        @solution.op_notice.add(read_ids)
        @solution.save

        brief = @solution.brief
        brief.op_notice.add(read_ids)
        brief.save
      end
      redirect_to vendor_solution_path(params[:solution_id])
    when (params[:add_5_tran] or params[:add_5_other])
      @kind_default = ['tran','other'].find{|e| params["add_5_#{e}"]} #add 5 tran or other
      n = 0
      n += 1 while params["name_#{n}"]
      @item_count = n+5
      render :action=>:new_many 
    end
  end

  def edit_many #test
    @solution = VendorSolution.find(params[:solution_id]) 

    items = @solution.items
    trans = []
    others = []
    items.each do |e|
      next unless e.op_right.check('self',@cur_user.org_id,'update')
      case e.kind
      when 'tran' then trans << e 
      when 'other' then others << e 
      end
    end

    @items = trans + others
  end

  def update_many #test
    solution = VendorSolution.find(params[:solution_id]) 
    items = params[:solution_item]
    brief = solution.brief

    ids = []
    items.keys.each{|e| ids << $1 if e =~ /name_(\d+)/}

    ids.each do |id|
      if (item = solution.items.where(:id=>id).first) and item.op_right.check('self',@cur_user.org_id,'update')
        item.name = items["name_#{id}"]
        item.quantity = items["quantity_#{id}"]
        item.note = items["note_#{id}"]
        item.price = items["price_#{id}"]
        item.tax_rate = items["tax_rate_#{id}"]
        item.kind = items["kind_#{id}"]
        notice_ids = item.op_notice.changed_by(@cur_user.org_id)
        if item.cal_save
          solution.op_notice.add(notice_ids)
          brief.op_notice.add(notice_ids)
        end
      end
    end

    solution.save
    brief.save

    redirect_to vendor_solution_path(solution)
  end
end
