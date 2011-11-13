#encoding=utf-8
class ItemsController < ApplicationController
  before_filter :cur_user 

  #get solutions/solution_id/items/change  
  def change_solution_items
    @solution = Solution.find(params[:solution_id])
    assigned_items = @solution.items.reject{|e| !(e.parent_id >0) }

    @assigned_item_ids = assigned_items.collect{|e| e.parent_id }

    @brief = @solution.brief
    render 'items/change_solution_items/show'
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

  #get 'briefs/:brief_id/items/new/:kind'=>:new,:as=>'new_brief_item'
  def new
    if params[:brief_id]
      @brief = Brief.find(params[:brief_id])
      @brief.check_edit_right(@cur_user)
      @item = @brief.items.new(:kind=>params[:kind])
      @path = brief_items_path(@brief,:dest=>bread_pre)
    end
    case @item.kind
    when 'design' then @title = '新建设计项'
    when 'product' then @title = '新建制作项'
    end
    render 'share/new_edit'
  end

  #get 'briefs/:brief_id/item/1/edit/'=>:edit,:as=>'edit_brief_item'
  def edit
    if params[:brief_id]
      @brief = Brief.find(params[:brief_id])
      @brief.check_edit_right(@cur_user)
      @item = @brief.items.find(params[:id])
      @path = brief_item_path(@brief,@item,:dest=>bread_pre)
    end
    case @item.kind
    when 'design' then @title = '修改设计项'
    when 'product' then @title = '修改制作项'
    end
    render 'share/new_edit'
  end

  #post 'briefs/:brief_id/items'=>:create,:as=>'brief_items'
  #post 'solutions/:solution_id/items/:id' => :create,
  #    :as=>'solution_item'
  def create
    if params[:brief_id]
      @brief = Brief.find(params[:brief_id])
      @brief.check_edit_right(@cur_user)
      @item = @brief.items.new(params[:brief_item])
      if @item.save
        redirect_to params[:dest], notice: 'Item was successfully created.' 
      else
        bread_pop!
        @path = brief_items_path(@brief,:back=>bread_pre)
        render action: "new" 
      end
    end
    if params[:solution_id]
      solution = Solution.find(params[:solution_id])
      brief = solution.brief
      item = brief.items.find(params[:id])
      unless solution.items.find_by_parent_id(params[:id])
        solution.items << SolutionItem.new(:parent_id=>item.id)
      end
      redirect_to bread_pre
    end
  end

  #put 'briefs/:brief_id/item/1'=>:update,:as=>'brief_item'
  def update
    if params[:brief_id]
      @brief = Brief.find(params[:brief_id])
      @brief.check_edit_right(@cur_user)
      @item = @brief.items.find(params[:id])

      if @item.update_attributes(params[:brief_item])
        redirect_to params[:dest], notice: 'Item was successfully updated.' 
      else
        render action: "edit" 
      end
    end
  end

  #delete 'briefs/:brief_id/item/1'=>:destroy,:as=>'brief_item'
  #delete 'solutions/:solution_id/items/:id' => :destroy,
  #    :as=>'solution_item'
  def destroy
    if params[:brief_id]
      @brief = Brief.find(params[:brief_id])
      @brief.check_edit_right(@cur_user)
      @item = @brief.items.find(params[:id])
      @item.destroy
      redirect_to bread_pre
    end
    if params[:solution_id]
      solution = Solution.find(params[:solution_id])
      brief = solution.brief
      item = brief.items.find(params[:id])
      solution_item = solution.items.find_by_parent_id(params[:id])
      solution_item.destroy
      redirect_to bread_pre
    end
  end
end
