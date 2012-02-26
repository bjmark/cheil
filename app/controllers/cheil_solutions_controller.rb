class CheilSolutionsController < ApplicationController
  before_filter :cur_user  

  def show
    @solution = CheilSolution.find(params[:id])
    
    invalid_op unless @solution.op_right.check('self',@cur_user.org_id,'read')

    if @solution.op_notice.include?(@cur_user.org_id)
      @solution.op_notice.del(@cur_user.org_id)
      @solutin.save
    end


    @brief = @solution.brief
    @attaches = @solution.checked_attaches
    @items = @solution.checked_items
    @comments = @solution.comments

    case @cur_user.org
    when RpmOrg
      @nav_link = :rpm
    when CheilOrg       
      @nav_link = :cheil
    end
  end

  def set_status
    solution = CheilSolution.find(params[:id])
    invalid_op if solution.org_id != @cur_user.org_id

    code = params[:code].to_i
    invalid_op unless [40,50].include?(code)

    brief = solution.brief
    brief.status = code 
    brief.send("status_#{code}=",Time.now)
    brief.op_notice.add(brief.rpm_id)
    brief.save

    redirect_to cheil_solution_path(solution)
  end

  def send_to_rpm
    solution = CheilSolution.find(params[:id])
    invalid_op if solution.org_id != @cur_user.org_id

    brief = solution.brief
    solution.op_right.add('self',brief.rpm_id,'read')
    solution.save

    brief.status = 20 #待审定
    brief.status_20 = Time.now
    brief.op_notice.add(brief.rpm_id)
    brief.save

    redirect_to cheil_solution_path(solution)
  end

  def approve
    solution = CheilSolution.find(params[:id])
    brief = solution.brief
    #solution.check_approve_right(@cur_user.org_id)
    invalid_op if brief.rpm_id != @cur_user.org_id

    solution.is_approved = ((block_given? and yield) or 'y')
    solution.approved_at = Time.now
    solution.save

    if solution.is_approved == 'y'
      brief.status = 30 #执行中
      brief.status_30 = Time.now
    else
      brief.status = 20 #待审定
    end

    brief.op_notice.add(brief.cheil_id)
    brief.save

    redirect_to cheil_solution_path(solution)
  end

  def unapprove
    approve{'n'}
  end

  def finish
    solution = CheilSolution.find(params[:id])
    invalid_op if solution.org_id != @cur_user.org_id

    brief = solution.brief
    brief.status = 60 #完成
    brief.status_60 = Time.now
    brief.op_notice.add(brief.rpm_id)
    brief.save

    solution.finish_at = Time.now
    solution.save
    redirect_to cheil_solution_path(solution)
  end

  def payment
    @solution = CheilSolution.find(params[:id])
    @brief = @solution.brief

    invalid_op if (@solution.org_id != @cur_user.org_id) and (@brief.rpm_id != @cur_user.org_id)

    @vendor_solutions = @brief.vendor_solutions

    @payments = Payment.where(:solution_id=>@solution.id).all
    case @cur_user.org
    when CheilOrg
      @nav = :cheil
    when RpmOrg
      @nav = :rpm
    end
  end
end
