class VendorSolutionsController < ApplicationController
  before_filter :cur_user , :check_right

  def check_right
    cheil = [:index,:show,:edit_rate,:update_rate,:destroy,:send_to_rpm,
      :finish,:unfinish,:new_many,:create_many,:pick_brief_items,:add_brief_item,:del_brief_item]
    vendor = [:show,:edit_rate,:update_rate]

    ok=case @cur_user.org
       when CheilOrg then cheil.include?(params[:action].to_sym)
       when VendorOrg then vendor.include?(params[:action].to_sym)
       else false
       end
    ok or (raise SecurityError) 
  end

  def index
    @brief = Brief.find(params[:brief_id])
    invalid_op unless @brief.op_right.check('vendor_solution',@cur_user.org_id,'read')

    @brief_items = @brief.items
    @vendor_solutions = @brief.vendor_solutions
  end

  def pick_brief_items 
    @vendor_solution = VendorSolution.find(params[:id])
    @brief = @vendor_solution.brief
  end

  def add_brief_item
    vendor_solution = VendorSolution.find(params[:id])
    invalid_op unless vendor_solution.op_right.check('item',@cur_user.org_id,'add_brief_item')

    if vendor_solution.items.where(:parent_id=>params[:brief_item_id]).blank?
      brief_item = BriefItem.find(params[:brief_item_id])
      #brief_item.add_to_solution(vendor_solution)
      item = vendor_solution.items.new(:parent_id=>brief_item.id)
      item.op_right.add('self',@cur_user.org_id,'read','del_brief_item','check')
      item.op_right.add('self',vendor_solution.org_id,'read','price')

      #notify the vendor for this item
      item.op_notice.add(vendor_solution.org_id)
      item.save

      #notify the vendor for this brief item
      brief_item.op_notice.add(vendor_solution.org_id)

      #the solution owner can read this brief_item
      brief_item.op_right.add('self',vendor_solution.org_id,'read')
      brief_item.save

      #notify the vendor for relate brief
      brief = vendor_solution.brief
      brief.op_notice.add(vendor_solution.org_id)
      brief.save
    end
    redirect_to pick_brief_items_vendor_solution_path(vendor_solution)
  end

  def del_brief_item
    vendor_solution = VendorSolution.find(params[:id])
    item = vendor_solution.items.where(:parent_id=>params[:brief_item_id]).first
    if item
      invalid_op unless item.op_right.check('self',@cur_user.org_id,'del_brief_item')
      item.destroy

      brief_item = BriefItem.find(params[:brief_item_id])
      brief_item.op_right.del('self',vendor_solution.org_id,'read')
      brief_item.save
    end
    redirect_to pick_brief_items_vendor_solution_path(vendor_solution)
  end

  def show
    @solution = VendorSolution.find(params[:id])
    invalid_op unless @solution.op_right.check('self',@cur_user.org_id,'read')

    @brief = @solution.brief
    @attaches = @solution.attaches
    @items = @solution.items

    flash[:dest] = solution_path(@solution)

    if @solution.op_notice.include?(@cur_user.org_id)
      @solution.op_notice.del(@cur_user.org_id)
      @solution.save
    end

    @money = @solution.money
    @payments = Payment.where(
      :solution_id=>@solution.brief.cheil_solution.id,
      :org_id=>@cur_user.org_id)

      case @cur_user.org
      when CheilOrg          #current user is a cheil user
        #render 'vendor_solutions/cheil/show'
        @nav_link = :cheil
      when VendorOrg
        @nav_link = :vendor
      end
  end

  def new_many
    #已被选中的vendors
    @brief = Brief.find(params[:brief_id])
    vs_ids = @brief.vendor_solutions.collect{|e| e.org_id}
    #所有org去除已被选中的vendor
    @vendors = [@brief.cheil_org] + VendorOrg.all
    @vendors = @vendors.reject{|e|vs_ids.include?(e.id)}
  end

  def create_many
    brief = Brief.find(params[:brief_id])
    #brief.check_create_solution_right(@cur_user.org_id)
    invalid_op unless brief.op_right.check('vendor_solution',@cur_user.org_id,'update')

    #get selected vendor org_id
    vendor_ids = []
    params.each {|k,v| vendor_ids << v if k=~/vendor\d+/}

    #create a vendor_solution from each selected vendor
    vendor_ids.each do |org_id|
      vs = brief.vendor_solutions.new(:org_id=>org_id)

      #the cheil has read and delete and assign_item right for the new vendor_solution
      vs.op_right.add('self',brief.cheil_id,'read','delete')
      vs.op_right.add('attach',brief.cheil_id,'read')
      vs.op_right.add('item',brief.cheil_id,'read','add_brief_item')
      vs.op_right.add('comment',brief.cheil_id,'read','update')

      #the vendor itself has read right for the new vendor_solution
      vs.op_right.add('self',org_id,'read')
      vs.op_right.add('attach',org_id,'read','update')
      vs.op_right.add('item',org_id,'read','create_tran_other','price_design_product')
      vs.op_right.add('comment',org_id,'read','update')
      vs.save

      #the vendor can read the brief and its attach
      brief.op_right.add('self',org_id,'read')
      brief.op_right.add('attach',org_id,'read')
      brief.op_right.add('item',org_id,'read')

      #notify the vendor it has new brief
      brief.op_notice.add(org_id)

      #the vendor can read all brief attaches
      brief.attaches.each do |e|
        e.op_right.add('self',org_id,'read')
        e.op_notice.add(org_id)
        e.save
      end
    end

    brief.save
    redirect_to vendor_solutions_path(:brief_id=>brief.id) 
  end

  def destroy
    vs = VendorSolution.find(params[:id])

    invalid_op unless vs.op_right.check('self',@cur_user.org_id,'delete')

    brief = vs.brief
    org_id = vs.org_id

    if brief.cheil_id != org_id
      brief.op_right.del('self',org_id,'read') 
      brief.op_right.del('attach',org_id,'read')
      brief.op_right.del('item',org_id,'read')
      brief.save

      brief.attaches.each do |e|
        e.op_right.del('self',org_id,'read')
        e.save
      end

      brief.items.each do |e|
        e.op_right.del('self',org_id,'read') 
        e.save
      end
    end
    vs.destroy

    redirect_to vendor_solutions_path(:brief_id=>brief.id) 
  end

  def edit_rate
    @solution = Solution.find(params[:id])
    @solution.check_edit_right(@cur_user.org_id)
  end

  def update_rate
    solution = Solution.find(params[:id])
    solution.check_edit_right(@cur_user.org_id)
    att = params[:vendor_solution] 
    solution.design_rate = att[:design_rate]
    solution.product_rate = att[:product_rate]
    solution.tran_rate = att[:tran_rate]
    solution.other_rate = att[:other_rate]
    solution.save

    redirect_to vendor_solution_path(solution)
  end


end
