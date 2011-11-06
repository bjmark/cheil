class CommentsController < ApplicationController
  before_filter :cur_user , :check_right

  def check_right
    case @cur_user.org
    when RpmOrg , CheilOrg
    else  raise SecurityError
    end
  end

  #get 'briefs/brief_id/comments/new' => :new,
  #  :as => 'new_brief_comment'
  def new
    if params[:brief_id]
      @brief = Brief.find(params[:brief_id])
      @brief.check_comment_right(@cur_user)
      @comment = Comment.new
      @back=params[:back]
      @path = brief_comments_path(@brief,:back=>@back)
    end
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
    redirect_to params[:back]
  end

  #delete 'briefs/:brief_id/comments/:comment_id' => :destroy,
  #  :as => 'brief_comment' 
  def destroy
    if params[:brief_id]
      brief = Brief.find(params[:brief_id])
      comment = brief.comments.find(params[:id])
      comment.check_destroy_right(@cur_user)
      comment.destroy
    end
    redirect_to params[:back] 
  end
end
