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
      @brief = Brief.find(params[:brief_id])
      @brief.check_comment_right(@cur_user)
      @comment = Comment.new
      @path = brief_comments_path(@brief,:dest=>bread_pre)
    end
    @title = '新建评论'
    render 'share/new_edit'
  end

  #post 'briefs/:brief_id/comments' => :create,
  #  :as => 'brief_comments'
  def create
    if params[:brief_id]
      brief = Brief.find(params[:brief_id])
      brief.check_comment_right(@cur_user)

      comment = BriefComment.new(params[:comment])
      comment.user_id = @cur_user.id
      brief.comments << comment
    end
    redirect_to params[:dest],notice: 'comment was successfully created.' 
  end

  def destroy
    comment = Comment.find(params[:id])
    comment.check_destroy_right(@cur_user)
    comment.destroy

    redirect_to owner_path(comment)
  end

end
