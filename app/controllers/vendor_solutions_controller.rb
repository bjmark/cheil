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
    if params[:brief_id]
      @brief = Brief.find(params[:brief_id])
      @brief.check_create_solution_right(@cur_user.org_id)
    end
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
    brief.check_create_solution_right(@cur_user.org_id)

    vendor_ids = []
    params.each {|k,v| vendor_ids << v if k=~/vendor\d+/}
    vendor_ids.each do |org_id|
      brief.vendor_solutions << VendorSolution.new(:org_id=>org_id,:read_by=>@cur_user.id.to_s)
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
end
