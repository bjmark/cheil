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

  def vendor_solution_total(solution)
    total = {}
    total_all = 0
    [:design,:product,:tran,:other].each do |k|
      total_all += (total[k] = solution.total(k))
    end
    total[:all] = total_all 
    
    return total
  end

  def show
    @solution = Solution.find(params[:id])
    case @cur_user.org
    when RpmOrg
      render 'briefs/rpm/show'
    when CheilOrg
      case
      when @solution.instance_of?(VendorSolution) 
        @total = vendor_solution_total(@solution)
        render 'solutions/cheil/vendor_solution/show'
      end
    when VendorOrg
      @total = vendor_solution_total(@solution)
      render 'solutions/vendor/show'
    end

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
