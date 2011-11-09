#encoding=utf-8
class ItemsController < ApplicationController
  before_filter :cur_user 

  def index
    @items = Item.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @items }
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

  #get 'briefs/:brief_id/items/new/:kind'=>:new,:as=>'new_brief_item'
  def new
    if params[:brief_id]
      @brief = Brief.find(params[:brief_id])
      @brief.check_edit_right(@cur_user)
      @item = @brief.items.new(:kind=>params[:kind])
      @back = params[:back]
      @path = brief_items_path(@brief,:back=>@back)
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
      @back = params[:back]
      @path = brief_item_path(@brief,@item,:back=>@back)
    end
    case @item.kind
    when 'design' then @title = '修改设计项'
    when 'product' then @title = '修改制作项'
    end
    render 'share/new_edit'
  end

  #post 'briefs/:brief_id/items'=>:create,:as=>'brief_items'
  def create
    if params[:brief_id]
      @brief = Brief.find(params[:brief_id])
      @brief.check_edit_right(@cur_user)
      @item = @brief.items.new(params[:brief_item])
      @back = params[:back]
      if @item.save
        redirect_to params[:back], notice: 'Item was successfully created.' 
      else
        @path = brief_items_path(@brief,:back=>@back)
        render action: "new" 
      end
    end
  end

  #put 'briefs/:brief_id/item/1'=>:update,:as=>'brief_item'
  def update
    if params[:brief_id]
      @brief = Brief.find(params[:brief_id])
      @brief.check_edit_right(@cur_user)
      @item = @brief.items.find(params[:id])

      if @item.update_attributes(params[:brief_item])
        redirect_to params[:back], notice: 'Item was successfully updated.' 
      else
        render action: "edit" 
      end
    end
  end

  #delete 'briefs/:brief_id/item/1'=>:destroy,:as=>'brief_item'
  def destroy
    if params[:brief_id]
      @brief = Brief.find(params[:brief_id])
      @brief.check_edit_right(@cur_user)
      @item = @brief.items.find(params[:id])
      @item.destroy
      redirect_to params[:back]
    end
  end
end
