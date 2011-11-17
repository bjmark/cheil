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
    if params[:brief_id]
      brief = Brief.find(params[:brief_id])
      brief.check_edit_right(@cur_user)
      @item = BriefItem.new
      @item.kind = params[:kind]
      @path = items_path(:brief_id=>brief.id)
      @back = brief_path(brief)
    end
  end

  def edit
    @item = Item.find(params[:id])
    @item.check_edit_right(@cur_user)
    @path = item_path(@item)
    @back = owner_path(@item)
  end

  def create
    if params[:brief_id]
      brief = Brief.find(params[:brief_id])
      brief.check_edit_right(@cur_user)
      @item = brief.items.new(params[:brief_item])
      @path = items_path(:brief_id=>brief.id)
      @back = owner_path(@item)
      if @item.save
        redirect_to @back, notice: 'Item was successfully created.'  and return
      else
        render action: "new"  and return
      end
    end

    if params[:solution_id] and params[:item_id]
      item = Item.find(params[:item_id])
      item.add_to_solution(params[:solution_id])
      redirect_to flash[:dest]
    end
  end

  def update
    @item = Item.find(params[:id])
    @item.check_edit_right(@cur_user)

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
    if params[:solution_id]
      item = Item.find(params[:id])
      item.del_from_solution(params[:solution_id])
      redirect_to flash[:dest] and return
    end

    item = Item.find(params[:id])
    item.check_edit_right(@cur_user)
    item.destroy
    flash[:dest] and redirect_to flash[:dest] and return
    redirect_to owner_path(item)
  end

end
