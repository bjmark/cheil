class BriefAttachesController < ApplicationController
  before_filter :cur_user 

  def new
    @brief = Brief.find(params[:brief_id])
    @attach = @brief.attaches.new
  end

  def create
    @brief = Brief.find(params[:brief_attach][:fk_id])
    invalid_op unless @brief.op_right.check('attach',@cur_user.org_id,'update')

    @attach = @brief.attaches.new(params[:brief_attach])
    @attach.op_right.set('self',@brief.rpm_id,'read','update','delete')
    if @brief.send_to_cheil?
      #set the rights for the cheil
      @attach.op_right.set('self',@brief.cheil_id,'read','update','delete')
      
      #all vendor who has a solution for this brief can see the new attach
      @brief.vendor_solutions.each do|e|
        @attach.op_right.set('self',e.org_id,'read')
      end
    end

    if @attach.op.save_by(@cur_user.id)
      @brief.op.touch(@cur_user.id)
      redirect_to brief_path(@brief)
    else
      render :action => 'new'
    end
  end

  def download
    attach = BriefAttach.find(params[:id])
    invalid_op unless attach.op_right.check('self',@cur_user.org_id,'read')

    attach.op.read_by(@cur_user.id)

    send_file attach.attach.path,
      :filename => attach.attach_file_name,
      :content_type => attach.attach_content_type
  end

  def destroy
    attach = BriefAttach.find(params[:id])
    invalid_op unless attach.op_right.check('self',@cur_user.org_id,'delete')
    attach.brief.op.touch(@cur_user.id)
    attach.destroy

    redirect_to brief_path(attach.brief)
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
      @attach.op.save_by(@cur_user.id)
      @brief.op.touch(@cur_user.id)
      redirect_to brief_path(@brief)
    else
      render action: "edit" 
    end
  end

end
