#encoding=utf-8
class CommentsController < ApplicationController
  before_filter :cur_user , :check_right

  def check_right
=begin
    case @cur_user.org
    when RpmOrg , CheilOrg
    else  raise SecurityError
    end
=end
  end

  def owner_path(comment)
    case comment
    when BriefComment 
      brief_path(comment.fk_id)
    when SolutionComment
      solution_path(comment.fk_id)
    end
  end

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
      @back = solution_path(solution)
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
    when
      solution = Solution.find(params[:solution_id])
      solution.check_comment_right(@cur_user.org_id)
      @comment = solution.comments.new(params[:solution_comment])
      @comment.user_id = @cur_user.id
      @path = comments_path(:solution_id=>solution.id)
    end

    @back = owner_path(@comment)

    if @comment.save
      redirect_to @back 
    else
      render :action => 'new'
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    comment.check_destroy_right(@cur_user)
    comment.destroy

    redirect_to owner_path(comment)
  end

end
