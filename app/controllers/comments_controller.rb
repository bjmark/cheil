#encoding=utf-8
class CommentsController < ApplicationController
  before_filter :cur_user 

  def new
    case 
    when params[:brief_id]
      brief = Brief.find(params[:brief_id])
      brief.check_comment_right(@cur_user.org_id)
      @comment = BriefComment.new
      @path = comments_path(:brief_id=>brief.id)
      @back = brief_path(brief)
    when
      solution = Solution.find(params[:solution_id])
      solution.check_comment_right(@cur_user.org_id)
      @comment = SolutionComment.new
      @path = comments_path(:solution_id=>solution.id)
      case solution
      when VendorSolution
        @back = vendor_solution_path(solution)
      when CheilSolution
        @back = cheil_solution_path(solution)
      end
    end
  end

  def create
    case
    when params[:brief_id]
      brief = Brief.find(params[:brief_id])
      brief.check_comment_right(@cur_user.org_id)
      @comment = brief.comments.new(params[:brief_comment])
      @comment.user_id = @cur_user.id
      @path = comments_path(:brief_id=>brief.id)
      @back = brief_path(brief)
    when
      solution = Solution.find(params[:solution_id])
      solution.check_comment_right(@cur_user.org_id)
      @comment = solution.comments.new(params[:solution_comment])
      @comment.user_id = @cur_user.id
      @path = comments_path(:solution_id=>solution.id)

      case solution
      when VendorSolution
        @back = vendor_solution_path(solution)
      when CheilSolution
        @back = cheil_solution_path(solution)
      end
    end

    if @comment.save
      redirect_to @back 
    else
      render :action => 'new'
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    comment.check_destroy_right(@cur_user)
    case comment
    when BriefComment
      dest = brief_path(comment.brief)
    when SolutionComment
      solution = comment.solution
      case solution
      when VendorSolution
        dest = vendor_solution_path(solution)
      when CheilSoluiton
        dest = cheil_solution_path(solution)
      end
    end
    comment.destroy

    redirect_to dest
  end
end
