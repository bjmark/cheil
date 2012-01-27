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
    set_checked('y')
  end

  def uncheck
    set_checked('n')
  end

end
