class VendorSolutionsController < ApplicationController
  before_filter :cur_user , :check_right

  def check_right
    cheil = [:index,:show,:edit_rate,:update_rate,:create,:destroy,:send_to_rpm,:finish,:unfinish]
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
  end

  def show
    @solution = VendorSolution.find(params[:id])
    @solution.check_read_right(@cur_user.org_id)
    flash[:dest] = solution_path(@solution)

    @solution.op.read_by(@cur_user.id)

    @money = @solution.money
    @payments = Payment.where(
      :solution_id=>@solution.brief.cheil_solution.id,
      :org_id=>@cur_user.org_id)

      case @cur_user.org
      when CheilOrg          #current user is a cheil user
        render 'vendor_solutions/cheil/show'
      when VendorOrg
        render 'vendor_solutions/vendor/show'
      end
  end

  def create
    brief = Brief.find(params[:brief_id])
    #brief.check_create_solution_right(@cur_user.org_id)
    invalid_op unless brief.op_right.check('vendor_solution',@cur_user.org_id,'update')

    #get selected vendor org_id
    vendor_ids = []
    params.each {|k,v| vendor_ids << v if k=~/vendor\d+/}
    
    #create a vendor_solution from each selected vendor
    vendor_ids.each do |org_id|
      vs = brief.vendor_solutions.new(:org_id=>org_id,:read_by=>@cur_user.id.to_s)
      
      #the cheil has read and delete and assign_item right for the new vendor_solution
      vs.op_right.set('self',brief.cheil_id,'read','delete','assign_item')
      vs.op_right.set('attach',brief.cheil_id,'read')
      vs.op_right.set('item',brief.cheil_id,'read')
      vs.op_right.set('comment',brief.cheil_id,'read','update')

      #the vendor itself has read right for the new vendor_solution
      vs.op_right.set('self',org_id,'read')
      vs.op_right.set('attach',org_id,'read','update')
      vs.op_right.set('item',org_id,'read','update')
      vs.op_right.set('comment',org_id,'read','update')
      vs.save

      #the vendor can read the brief
      brief.op_right.set('self',org_id,'read')
      brief.save

      #the vendor can read all brief attaches
      brief.attaches.each do |e|
        e.op_right.set('self',org_id,'read')
        e.save
      end
    end

    redirect_to vendor_solutions_path(:brief_id=>brief.id) 
  end

  def destroy
    s = VendorSolution.find(params[:id])
    brief = s.brief
    s.check_destroy_right(@cur_user.org_id)
    s.destroy

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
