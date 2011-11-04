class CommentsController < ApplicationController
  before_filter :cur_user

  
  #get 'briefs/brief_id/comments/new' => :new_brief_comment,
  #  :as => 'new_brief_comment'
  def new_brief_comment
    @brief = Brief.find(params[:brief_id])
    @brief.can_comment?(@cur_user)
    
    @comment = Comment.new
    @back = params[:back]
    @path = create_brief_comment_path(@brief,:back => @back) 
  end

  #post 'briefs/:brief_id/comments' => :create_brief_comment,
  #  :as => 'create_brief_comment'
  def create_brief_comment
    brief = Brief.find(params[:brief_id])
    brief.can_comment?(@cur_user)
    
    comment = BriefComment.new(params[:comment])
    comment.user_id = @cur_user.id
    brief.comments << comment

    redirect_to params[:back]
  end

  #delete 'briefs/:brief_id/comments/:comment_id' => :destroy_brief_comment,
  #  :as => 'destroy_brief_comment' 
  def destroy_brief_comment
    brief = Brief.find(params[:brief_id])
    brief.can_comment?(@cur_user)

    comment = brief.comments.find(params[:comment_id])
    comment.destroy

    respond_to do |format|
      format.html { redirect_to params[:back] }
      format.json { head :ok }
    end
  end
end
