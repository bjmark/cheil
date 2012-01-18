#encoding=utf-8
class ItemsController < ApplicationController
  before_filter :cur_user 

  def index
    if params[:solution_id]
      @solution = Solution.find(params[:solution_id])
      @brief = @solution.brief
      render 'items/index1/index'
    end
  end
  
  def owner_path(item)
    case item
    when BriefItem 
      brief_path(item.fk_id)
    when SolutionItem
      solution_path(item.fk_id)
    end
  end

  # GET /items/1
  # GET /items/1.json
=begin
  def show
    @item = Item.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @item }
    end
  end
=end
  def new
    case
      # new a item for a brief
    when params[:brief_id] 
      brief = Brief.find(params[:brief_id])
      brief.check_edit_right(@cur_user.org_id)
      @item = BriefItem.new
      @item.kind = params[:kind]
      @path = items_path(:brief_id=>brief.id)
      @back = brief_path(brief)
      # new a item for a solution
    when params[:solution_id]
      solution = Solution.find(params[:solution_id])
      solution.check_edit_right(@cur_user.org_id)
      @item = SolutionItem.new
      @item.kind = params[:kind]
      @path = items_path(:solution_id=>solution.id)
      @back = solution_path(solution)
      @form = 'tran_form'
    else
      raise SecurityError
    end
  end

  def edit
    @item = Item.find(params[:id])
    @item.check_edit_right(@cur_user.org_id)
    @path = item_path(@item)
    @back = owner_path(@item)
    @form = case 
            when (params[:spec] == 'price') then 'price_form'
            when ['tran','other'].include?(@item.kind) then 'tran_form'
            end
  end

  def create
    case
      #add a brief_item to vendor_solution
    when (params[:solution_id] and params[:item_id])
      solution = VendorSolution.find(params[:solution_id])
      raise SecurityError unless solution.brief.received_by?(@cur_user.org_id)

      item = BriefItem.find(params[:item_id])
      item.add_to_solution(solution)
      redirect_to(items_path(:solution_id=>solution.id)) and return

      #create a brief_item
    when params[:brief_id]
      brief = Brief.find(params[:brief_id])
      brief.check_edit_right(@cur_user.org_id)
      @item = brief.items.new(params[:brief_item])
      @path = items_path(:brief_id=>brief.id)
      @back = owner_path(@item)

      brief.op.touch(@cur_user.id)

      #create a solution_item
    when params[:solution_id]
      solution = Solution.find(params[:solution_id])
      solution.check_edit_right(@cur_user.org_id)
      @item = solution.items.new(params[:solution_item])
      @path = items_path(:solution_id=>solution.id)
      @back = owner_path(@item)
      @form = 'tran_form'

      solution.op.touch(@cur_user.id)
    else
      raise SecurityError
    end

    if @item.op.save_by(@cur_user.id)
      redirect_to @back, notice: 'Item was successfully created.' 
    else
      render action: "new" 
    end
  end

  def set_checked(value)
    item = Item.find(params[:id])
    raise SecurityError unless item.solution.brief.received_by?(@cur_user.org_id)
    item.checked = value
    item.save
    redirect_to (flash[:dest] or solution_path(item.fk_id))
  end

  def check
    set_checked('y')
  end

  def uncheck
    set_checked('n')
  end

  def update
    @item = Item.find(params[:id])
    @item.check_edit_right(@cur_user.org_id)

    case @item
    when BriefItem 
      attr = params[:brief_item]
      @item.brief.op.touch(@cur_user.id)
    when SolutionItem
      @item.solution.op.touch(@cur_user.id)
      attr = params[:solution_item]
    end

    @path = item_path(@item)
    @back = owner_path(@item)

    if @item.update_attributes(attr)
      @item.op.save_by(@cur_user.id)
      redirect_to @back, notice: 'Item was successfully updated.' 
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
      redirect_to(items_path(:solution_id=>solution.id)) and return
    when params[:id]
      item = Item.find(params[:id])
      item.check_edit_right(@cur_user.org_id)

      case item
      when BriefItem 
        item.brief.op.touch(@cur_user.id)
      when SolutionItem
        item.solution.op.touch(@cur_user.id)
      end

      item.destroy
      redirect_to(owner_path(item)) and return
    else
      raise SecurityError
    end
  end

end
