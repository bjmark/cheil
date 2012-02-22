class CheilSolutionsController < ApplicationController
  before_filter :cur_user  

  def show
    @solution = CheilSolution.find(params[:id])
    #@solution.check_read_right(@cur_user.org_id)
    invalid_op unless @solution.op_right.check('self',@cur_user.org_id,'read')
    #@solution.op.read_by(@cur_user.id)
    if @solution.op_notice.include?(@cur_user.org_id)
      @solution.op_notice.del(@cur_user.org_id)
      @solutin.save
    end

    @payments = Payment.where(:solution_id=>@solution.id).all

    @brief = @solution.brief
    @attaches = @solution.checked_attaches

    case @cur_user.org
    when RpmOrg
      render 'show_rpm'
    when CheilOrg       
      render 'cheil_solutions/cheil/show'
    end
  end

  def set_status(solution,status_code)
    solution.check_edit_right(@cur_user.org.id)
    brief = solution.brief
    brief.status = status_code
    brief.save
  end

  def send_to_rpm
    solution = CheilSolution.find(params[:id])
    set_status(solution,2)
    redirect_to cheil_solution_path(solution)
  end

  def approve
    solution = CheilSolution.find(params[:id])
    solution.check_approve_right(@cur_user.org_id)
    solution.is_approved = ((block_given? and yield) or 'y')
    solution.approved_at = Time.now
    solution.save

    brief = solution.brief
    brief.status = solution.is_approved == 'y' ? 3 : 2
    brief.save

    redirect_to cheil_solution_path(solution)
  end

  def unapprove
    approve{'n'}
  end

  def finish
    solution = CheilSolution.find(params[:id])
    set_status(solution,4)
    solution.finish_at = Time.new
    solution.save
    redirect_to cheil_solution_path(solution)
  end

  def unfinish
    solution = CheilSolution.find(params[:id])
    set_status(solution,3)
    redirect_to cheil_solution_path(solution)
  end

end
