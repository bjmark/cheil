#encoding=utf-8
class CommentsController < ApplicationController
  before_filter :cur_user , :check_right

  def check_right
    case @cur_user.org
    when RpmOrg , CheilOrg
    else  raise SecurityError
    end
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
    if params[:brief_id]
      brief = Brief.find(params[:brief_id])
      brief.check_comment_right(@cur_user)
      @comment = BriefComment.new
      @path = comments_path(:brief_id=>brief.id)
      @back = brief_path(brief)
    end
  end

  def create
    if params[:brief_id]
      brief = Brief.find(params[:brief_id])
      brief.check_comment_right(@cur_user)
      @comment = brief.comments.new(params[:brief_comment])
      @comment.user_id = @cur_user.id
      @path = comments_path(:brief_id=>brief.id)
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
