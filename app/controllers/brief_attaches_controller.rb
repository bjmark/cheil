class BriefAttachesController < ApplicationController
  before_filter :cur_user 

  def new
    @brief = Brief.find(params[:brief_id])
    @attach = @brief.attaches.new
  end

  def create
    @brief = Brief.find(params[:brief_attach][:fk_id])
    invalid_op unless @brief.op_right.check('attach',@cur_user.org_id,'update')

    update_ids = @brief.op_right.who_has('attach','update')
    read_ids = @brief.op_right.who_has('attach','read')

    @attach = @brief.attaches.new(params[:brief_attach])
    
    @attach.op_right.add('self',update_ids,'read','update','delete')
    @attach.op_right.add('self',read_ids,'read')
    
    #who should be notified
    notice_org_ids = @attach.op_notice.changed_by(@cur_user.org_id)

    if @attach.save
      #change extend to brief
      @brief.op_notice.add(notice_org_ids)
      @brief.save
      redirect_to brief_path(@brief)
    else
      render :action => 'new'
    end
  end

  def download
    attach = BriefAttach.find(params[:id])
    invalid_op unless attach.op_right.check('self',@cur_user.org_id,'read')

    send_file attach.attach.path,
      :filename => attach.attach_file_name,
      :content_type => attach.attach_content_type
    
    #del the notice
    attach.op_notice.del(@cur_user.org_id)
    attach.save
  end

  def destroy
    attach = BriefAttach.find(params[:id])
    invalid_op unless attach.op_right.check('self',@cur_user.org_id,'delete')
    
    brief = attach.brief
    notice_org_ids = attach.op_right.who_has('self','read') - [@cur_user.org_id]
    
    brief.op_notice.add(notice_org_ids)
    brief.save
    
    attach.destroy

    redirect_to brief_path(brief)
  end

  def edit
    @attach = BriefAttach.find(params[:id])
    @brief = @attach.brief
  end

  def update
    @attach = BriefAttach.find(params[:id])
    @brief = @attach.brief
    invalid_op unless @attach.op_right.check('self',@cur_user.org_id,'update')

    attr = params[:brief_attach]
    if @attach.update_attributes(attr)
      notice_org_ids = @attach.op_notice.changed_by(@cur_user.org_id)
      @attach.save

      @brief.op_notice.add(notice_org_ids)
      @brief.save

      redirect_to brief_path(@brief)
    else
      render action: "edit" 
    end
  end

end
