class SolutionItemsController < ApplicationController
  before_filter :cur_user 

  def index
    if params[:solution_id]
      @solution = Solution.find(params[:solution_id])
      @brief = @solution.brief
    end
  end

  def new
    @solution = Solution.find(params[:solution_id])
    @solution.check_edit_right(@cur_user.org_id)
    @item = @solution.items.new
    @item.kind = params[:kind]
  end

  def edit
    @item = Item.find(params[:id])
    @item.check_edit_right(@cur_user.org_id)
    @solution = @item.solution
  end

  def edit_price
    @solution_item = SolutionItem.find(params[:id])
    @solution_item.check_edit_right(@cur_user.org_id)
  end

  def update_price
    @item = Item.find(params[:id])
    @item.check_edit_right(@cur_user.org_id)

    attr = params[:solution_item]
    @item.note = attr[:note]
    @item.price = attr[:price]

    @item.save
    @item.solution.op.touch(@cur_user.id)

    redirect_to vendor_solution_path(@item.solution)  
  end

  def edit_price_many
    @solution = VendorSolution.find(params[:solution_id])
    @solution.check_edit_right(@cur_user.org_id)

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

  def update_price_many
    solution = VendorSolution.find(params[:solution_id])
    solution.check_edit_right(@cur_user.org_id)

    items = params[:solution_item]

    ids = []
    items.keys.each{|e| ids << $1 if e =~ /price_(\d+)/}

    updated_count = 0

    ids.each do |id|
      if item = solution.items.where(:id=>id).first
        item.note = items["note_#{id}"]
        item.price = items["price_#{id}"]
        if item.op.save_by(@cur_user.id)
          updated_count += 1
        end
      end
    end

    if updated_count > 0
      solution.op.touch(@cur_user.id)
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

  def create
    case
      #add a brief_item to vendor_solution
    when (params[:solution_id] and params[:item_id])
      solution = VendorSolution.find(params[:solution_id])
      raise SecurityError unless solution.brief.received_by?(@cur_user.org_id)

      item = BriefItem.find(params[:item_id])
      item.add_to_solution(solution)
      redirect_to(solution_items_path(:solution_id=>solution.id)) and return
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

  def update
    @item = Item.find(params[:id])
    @item.check_edit_right(@cur_user.org_id)

    attr = params[:solution_item]
    set_attr(attr)

    if @item.op.save_by(@cur_user.id)
      @item.solution.op.touch(@cur_user.id)
      redirect_to vendor_solution_path(@item.solution), notice: 'Item was successfully updated.' 
    else
      render action: "edit" 
    end
  end


  def destroy
    case
    when (params[:id] and params[:solution_id])
      solution = VendorSolution.find(params[:solution_id])
      raise SecurityError unless solution.brief.received_by?(@cur_user.org_id)
      item = Item.find(params[:id])
      item.del_from_solution(params[:solution_id])
      redirect_to(solution_items_path(:solution_id=>solution.id)) and return
    when params[:id]
      item = Item.find(params[:id])
      item.check_edit_right(@cur_user.org_id)

      item.solution.op.touch(@cur_user.id)
      item.destroy
      redirect_to(vendor_solution_path(item.solution)) and return
    else
      raise SecurityError
    end
  end

  def set_checked(value)
    item = Item.find(params[:id])
    raise SecurityError unless item.solution.brief.received_by?(@cur_user.org_id)
    item.checked = value
    item.save
    redirect_to vendor_solution_path(item.solution)
  end

  def check
    item = SolutionItem.find(params[:id])
    raise SecurityError unless item.solution.brief.received_by?(@cur_user.org_id)
    value = 'y'
    if block_given? 
      value = yield
    end
    item.checked = value
    item.save
    if params[:dest]
      redirect_to params[:dest]
    else
      redirect_to vendor_solution_path(item.solution)
    end
  end

  def uncheck
    check{'n'}
  end

  #solution_items/new/many?solution_id=1&kind=design         new many items for a vendor_solution
  def new_many
    @solution = VendorSolution.find(params[:solution_id]) 
    @kind_default = params[:kind]
    @item_count = 5
  end

  def create_many
    @solution = VendorSolution.find(params[:solution_id]) 
    @solution.check_edit_right(@cur_user.org_id)     #check right

    case
    when params[:save_many]
      n = 0
      saved_count = 0
      while params["name_#{n}"]
        attr = {}
        %w{name quantity note kind}.each {|e| attr[e] = params["#{e}_#{n}"]}
        item = @solution.items.new(attr)
        if item.op.save_by(@cur_user.id)
          saved_count += 1
        end
        n += 1
      end
      if saved_count > 0
        @solution.op.touch(@cur_user.id)
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

  def edit_many
    @solution = VendorSolution.find(params[:solution_id]) 
    @solution.check_edit_right(@cur_user.org_id)     #check right

    items = @solution.items
    trans = []
    others = []
    items.each do |e|
      case e.kind
      when 'tran' then trans << e
      when 'other' then others << e
      end
    end

    @items = trans + others
  end

  def update_many
    solution = VendorSolution.find(params[:solution_id]) 
    solution.check_edit_right(@cur_user.org_id)     #check right
    items = params[:solution_item]

    ids = []
    items.keys.each{|e| ids << $1 if e =~ /name_(\d+)/}

    updated_count = 0

    ids.each do |id|
      if item = solution.items.where(:id=>id).first
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
      solution.op.touch(@cur_user.id)
    end

    redirect_to vendor_solution_path(params[:solution_id])
  end
end
