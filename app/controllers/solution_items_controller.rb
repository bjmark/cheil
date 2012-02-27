#encoding=utf-8
class SolutionItemsController < ApplicationController
  before_filter :cur_user 

  def edit
    @item = SolutionItem.find(params[:id])
    invalid_op unless @item.op_right.check('self',@cur_user.org_id,'update')
    @solution = @item.solution
  end

  def update
    @item = SolutionItem.find(params[:id])
    invalid_op unless @item.op_right.check('self',@cur_user.org_id,'update')

    attr = params[:solution_item]

    @item.name = attr[:name]
    @item.quantity = attr[:quantity]
    @item.note = attr[:note]
    @item.price = attr[:price]
    @item.tax_rate = attr[:tax_rate]
    @item.kind = attr[:kind]

    notice_ids = @item.op_notice.changed_by(@cur_user.org_id)

    if @item.cal_save
      solution = @item.solution
      solution.op_notice.add(notice_ids)
      solution.cal
      solution.save

      brief = solution.brief
      brief.op_notice.add(notice_ids)
      brief.save

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
    solution.cal
    solution.save

    brief = solution.brief
    brief.op_notice.add(notice_ids)
    brief.save

    redirect_to vendor_solution_path(solution)  
  end

  def edit_price_many #tested
    @solution = VendorSolution.find(params[:solution_id])
    invalid_op unless @solution.op_right.check('item',@cur_user.org_id,'price_design_product')

    items = @solution.items.find_all{|e| e.op_right.check('self',@cur_user.org_id,'price')}
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
      if !(item = solution.items.where(:id=>id).first).blank? and item.op_right.check('self',@cur_user.org_id,'price')
        item.note = items["note_#{id}"]
        item.price = items["price_#{id}"]
        item.tax_rate = items["tax_rate_#{id}"]

        notice_ids = item.op_notice.changed_by(@cur_user.org_id)

        solution.op_notice.add(notice_ids)
        brief.op_notice.add(notice_ids)

        item.cal_save
      end
    end

    solution.cal
    solution.save
    brief.save
    redirect_to vendor_solution_path(params[:solution_id])
  end

  def edit_score_many
    @solution = VendorSolution.find(params[:solution_id])
    invalid_op unless @solution.op_right.check('item',@cur_user.org_id,'update_score')

    items = @solution.items
    designs = []
    products = []
    trans = []
    others = []

    items.each do |e|
      case e.kind
      when 'design' then designs << e
      when 'product' then products << e
      when 'tran' then trans << e
      when 'other' then others << e
      end
    end

    @items = designs + products + trans + others

  end

  def update_score_many
    solution = VendorSolution.find(params[:solution_id])
    invalid_op unless solution.op_right.check('item',@cur_user.org_id,'update_score')

    items = params[:solution_item]

    ids = []
    items.keys.each{|e| ids << $1 if e =~ /score_(\d+)/}

    brief = solution.brief

    ids.each do |id|
      if !(item = solution.items.where(:id=>id).first).blank?
        item.score = items["score_#{id}"]
        item.save
      end
    end

    redirect_to vendor_solution_path(params[:solution_id])
  end

  def set_attr(attr)
    @item.name = attr[:name]
    @item.quantity = attr[:quantity]
    @item.note = attr[:note]
    @item.price = attr[:price]
    @item.kind = attr[:kind]
  end

  def destroy #tested
    item = SolutionItem.find(params[:id])
    invalid_op unless item.op_right.check('self',@cur_user.org_id,'delete')

    notice_ids = item.op_notice.changed_by(@cur_user.org_id)
    item.destroy

    solution = item.solution
    solution.op_notice.add(notice_ids)
    solution.cal
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
    case value
    when 'y'
      item.op_right.disable('self','update','delete','price')
    when 'n'
      item.op_right.enable('self','update','delete','price')
    end
    item.save

    solution = item.solution
    solution.op_notice.add(notice_ids)
    solution.cal
    solution.save

    brief = solution.brief
    brief.op_notice.add(notice_ids)
    brief.save

    cheil_solution = brief.cheil_solution
    cheil_solution.cal
    cheil_solution.save

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
        @solution.cal
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

    solution.cal
    solution.save
    brief.save

    redirect_to vendor_solution_path(solution)
  end
end
