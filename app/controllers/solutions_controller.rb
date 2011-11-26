#encoding=utf-8
class SolutionsController < ApplicationController
  before_filter :cur_user , :check_right

  def check_right
  end

  def index
    if params[:brief_id]
      @brief = Brief.find(params[:brief_id])
    end
  end

  def show
    @solution = Solution.find(params[:id])
    flash[:dest] = solution_path(@solution)
    case @cur_user.org
    when RpmOrg
      render 'solutions/rpm/show'
    when CheilOrg
      case
      when @solution.instance_of?(VendorSolution) 
        render 'solutions/cheil/vendor_solution/show'
      when @solution.instance_of?(CheilSolution)
        render 'solutions/cheil/cheil_solution/show'
      end
    when VendorOrg
      render 'solutions/vendor/show'
    end

  end

  def edit_rate
    @solution = Solution.find(params[:id])
  end

  def update_rate
    solution = Solution.find(params[:id])
    att = params[:vendor_solution] 
    solution.design_rate = att[:design_rate]
    solution.product_rate = att[:product_rate]
    solution.tran_rate = att[:tran_rate]
    solution.other_rate = att[:other_rate]
    solution.save

    redirect_to solution_path(solution)
  end

  def create
    brief = Brief.find(params[:brief_id])
    vendor_ids = []
    params.each {|k,v| vendor_ids << v if k=~/vendor\d+/}
    vendor_ids.each do |org_id|
      brief.vendor_solutions << VendorSolution.new(:org_id=>org_id)
    end

    redirect_to solutions_path(:brief_id=>brief.id) 
  end

  def destroy
    s = Solution.find(params[:id])
    brief = s.brief
    s.check_destroy_right(@cur_user)
    s.destroy

    redirect_to solutions_path(:brief_id=>brief.id) 
  end
end
