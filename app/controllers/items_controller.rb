#encoding=utf-8
class ItemsController < ApplicationController
  before_filter :cur_user 

  def index
    if params[:solution_id]
      @solution = Solution.find(params[:solution_id])
      @brief = @solution.brief
      flash[:dest] = items_path(:solution_id=>@solution.id)
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
  def show
    @item = Item.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @item }
    end
  end

  def new
    case
    when params[:brief_id]
      brief = Brief.find(params[:brief_id])
      brief.check_edit_right(@cur_user.org_id)
      @item = BriefItem.new
      @item.kind = params[:kind]
      @path = items_path(:brief_id=>brief.id)
      @back = brief_path(brief)
    when params[:solution_id]
      solution = Solution.find(params[:solution_id])
      solution.check_edit_right(@cur_user.org_id)
      @item = SolutionItem.new
      @item.kind = params[:kind]
      @path = items_path(:solution_id=>solution.id)
      @back = solution_path(solution)
      @form = 'tran_form'
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
      #add a item to solution
    when (params[:solution_id] and params[:item_id])
      item = Item.find(params[:item_id])
      item.add_to_solution(params[:solution_id])
      redirect_to flash[:dest] and return

      #create a brief_item
    when params[:brief_id]
      brief = Brief.find(params[:brief_id])
      brief.check_edit_right(@cur_user.org_id)
      @item = brief.items.new(params[:brief_item])
      @path = items_path(:brief_id=>brief.id)
      @back = owner_path(@item)

      #create a solution_item
    when params[:solution_id]
      solution = Solution.find(params[:solution_id])
      solution.check_edit_right(@cur_user.org_id)
      @item = solution.items.new(params[:solution_item])
      @path = items_path(:solution_id=>solution.id)
      @back = owner_path(@item)
      @form = 'tran_form'
    end

    if @item.save
      redirect_to @back, notice: 'Item was successfully created.' 
    else
      render action: "new" 
    end
  end

  def set_checked(value)
    item = Item.find(params[:id])
    item.checked = value
    item.save
    redirect_to flash[:dest] or solution_path(item.fk_id)
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
    when SolutionItem
      attr = params[:solution_item]
    end

    @path = item_path(@item)
    @back = owner_path(@item)

    if @item.update_attributes(attr)
      redirect_to @back, notice: 'Item was successfully updated.' 
    else
      render action: "edit" 
    end
  end

  def destroy
    case
    when params[:solution_id]
      item = Item.find(params[:id])
      item.del_from_solution(params[:solution_id])
    else
      item = Item.find(params[:id])
      item.check_edit_right(@cur_user)
      item.destroy
    end
    redirect_to (flash[:dest] or owner_path(item))
  end

end
