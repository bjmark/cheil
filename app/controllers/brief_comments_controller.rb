#encoding=utf-8
class BriefCommentsController < ApplicationController
  before_filter :cur_user 

  def new
    @brief = Brief.find(params[:brief_id])
    @comment = @brief.comments.new
  end

  def create
    @brief = Brief.find(params[:brief_comment][:fk_id])
    invalid_op unless @brief.op_right.check('comment',@cur_user.org_id,'update')
    
    @comment = @brief.comments.new(params[:brief_comment])
    @comment.user_id = @cur_user.id

    #get who can read this brief comment
    org_ids = @brief.op_right.who_has('comment','read')
    @comment.op_right.set('self',org_ids,'read')
    
    #the creator has delete right
    @comment.op_right.add('self',@cur_user.org_id,'delete')

    #who should be notice
    notice_org_ids = org_ids - [@cur_user.org_id]
    @comment.op_notice.add(notice_org_ids) unless notice_org_ids.blank?

    if @comment.save
      unless notice_org_ids.blank?
        @brief.op_notice.add(notice_org_ids)
        @brief.save
      end
      redirect_to brief_path(@brief) 
    else
      render :action => 'new'
    end
  end

  def destroy
    comment = BriefComment.find(params[:id])
    invalid_op unless comment.op_right.check('self',@cur_user.org_id,'delete')
    comment.destroy
    redirect_to brief_path(comment.fk_id)
  end

end
