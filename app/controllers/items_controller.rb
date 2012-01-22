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

  
  def new
    case
      #items/new?brief_id=1&kind=design      new a item for a brief
      #items/new?brief_id=1&many=yes         new many items for a brief
    when params[:brief_id] 
      aid = BriefItemAid.new(self)
      aid.check_right(:new,@cur_user)
      case 
      when aid.new_one?
        @var = aid.new_one
        render 'items/brief/new' and return

      when aid.new_many?
        @var = aid.new_many
        render 'items/brief/new_many' and return
      end

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

      #create a brief_item or many brief_items
    when params[:brief_id]
      case 
      when params[:save_one]
        aid = BriefItemAid.new(self)
        aid.check_right(:new,@cur_user)
        @var = aid.save_one_by(@cur_user)
        if @var.blank?
          redirect_to brief_path(params[:brief_id]), notice: 'Item was successfully created.'  
        else
          render 'items/brief/new' 
        end
        return
      when kind = ['design','product'].find{|e| params["add_5_#{e}"]}
        aid = BriefItemAid.new(self)
        @var = aid.add_5(kind)
        render 'items/brief/new_many' and return
      when params[:save_many]
        aid = BriefItemAid.new(self)
        aid.check_right(:new,@cur_user)
        aid.save_many_by(@cur_user)
        redirect_to brief_path(params[:brief_id]) and return  
      end

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


class ItemsController 
  class BriefItemAid
    def initialize(contr)
      @contr = contr
    end

    def contr
      @contr
    end

    def params
      @contr.params
    end

    def brief
      @brief ||= Brief.find(params[:brief_id]) 
    end

    def check_right(op,cur_user)
      case op
      when :new
        brief.check_edit_right(cur_user.org_id)     #check right
      end
    end

    def new_many?
      params[:many] == 'yes'
    end

    def new_one?
      !new_many?
    end

    def post_path
      contr.items_path(:brief_id=>brief.id)      
    end

    def back_path
      contr.brief_path(brief)
    end

    def new_one_var(item)
      kind = {'design' => '设计项','product'=>'制造项'}
      title = "新建#{kind[params[:kind]]} (#{brief.name})"
      {
        :item => item,
        :title => title,
        :post_path => post_path,
        :back_path => back_path
      }
    end

    def new_one
      item = brief.items.new
      item.kind = params[:kind]
      new_one_var(item)
    end

    def save_one_by(cur_user)
      item = brief.items.new(params[:brief_item])
      var =
        if item.op.save_by(cur_user.id)
          brief.op.touch(cur_user.id)
          {}
        else
          new_one_var(item)
        end
    end

    def new_many_var(item_count,default='design')
      title = "新建子项 (#{brief.name})"
      {
        :title => title,
        :default => default,
        :item_count => item_count,
        :post_path => post_path,
        :back_path => back_path
      }
    end

    def new_many
      new_many_var(5)
    end

    def add_5(default = 'design')
      n = 0
      n += 1 while params["name_#{n}"]
      item_count = n+5
      new_many_var(item_count,default)
    end

    def save_many_by(cur_user)
      n = 0
      saved_count = 0
      while params["name_#{n}"]
        attr = {}
        %w{name quantity note kind}.each {|e| attr[e] = params["#{e}_#{n}"]}
        item = brief.items.new(attr)
        if item.op.save_by(cur_user.id)
          saved_count += 1
        end
        n += 1
      end
      if saved_count > 0
        brief.op.touch(cur_user.id)
      end

      return saved_count 
    end

  end
end
