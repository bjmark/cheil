class SolutionCommentsController < ApplicationController
  before_filter :cur_user 

  def new
    @solution = Solution.find(params[:solution_id])
    @comment = @solution.comments.new
  end

  def create
    @solution = Solution.find(params[:solution_comment][:fk_id])
    invalid_op unless @solution.op_right.check('comment',@cur_user.org_id,'update')

    @comment = @solution.comments.new(params[:solution_comment])
    @comment.user_id = @cur_user.id

    #get who can read this brief comment
    read_ids = @solution.op_right.who_has('comment','read')
    @comment.op_right.set('self',read_ids,'read')

    #the creator has delete right
    @comment.op_right.add('self',@cur_user.org_id,'delete')

    #who should be notice
    notice_ids = @comment.op_notice.changed_by(@cur_user.org_id)

    if @comment.save
      unless notice_ids.blank?
        brief = @solution.brief
        brief.op_notice.add(notice_ids)
        brief.save
      end
      case @solution
      when VendorSolution 
        redirect_to vendor_solution_path(@solution)
      when CheilSolution
        redirect_to cheil_solution_path(@solution)
      end
    else
      render :action => 'new'
    end
  end

  def destroy
    comment = SolutionComment.find(params[:id])
    solution = comment.solution
    invalid_op unless comment.op_right.check('self',@cur_user.org_id,'delete')
    comment.destroy

    case solution
    when VendorSolution 
      redirect_to vendor_solution_path(solution)
    when CheilSolution
      redirect_to cheil_solution_path(solution)
    end
  end
end
