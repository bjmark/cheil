class SolutionAttachesController < ApplicationController
  before_filter :cur_user 

  def new
    @solution = VendorSolution.find(params[:solution_id])
    @attach = @solution.attaches.new
  end

  def create
    @solution = VendorSolution.find(params[:solution_attach][:fk_id])
    invalid_op unless @solution.op_right.check('attach',@cur_user.org_id,'update')

    update_ids = @solution.org_id
    read_ids = @solution.op_right.who_has('attach','read')

    @attach = @solution.attaches.new(params[:solution_attach])

    @attach.op_right.add('self',update_ids,'read','update','delete')
    @attach.op_right.add('self',read_ids,'read')
    @attach.op_right.add('self',read_ids,'read')

    brief = @solution.brief
    @attach.op_right.add('self',brief.cheil_id,'check')

    #who should be notified
    notice_org_ids = @attach.op_right.who_has('self','read') - [@cur_user.org_id]
    @attach.op_notice.add(notice_org_ids)

    if @attach.save
      @solution.op_notice.add(notice_org_ids)
      @solution.save

      brief.op_notice.add(notice_org_ids)
      brief.save

      redirect_to vendor_solution_path(@solution)
    else
      render :action => 'new'
    end
  end

  def download
    attach = SolutionAttach.find(params[:id])
    invalid_op unless attach.op_right.check('self',@cur_user.org_id,'read')

    send_file attach.attach.path,
      :filename => attach.attach_file_name,
      :content_type => attach.attach_content_type

    #del the notice
    attach.op_notice.del(@cur_user.org_id)
    attach.save
  end

  def destroy
    attach = SolutionAttach.find(params[:id])
    invalid_op unless attach.op_right.check('self',@cur_user.org_id,'delete')

    solution = attach.solution
    notice_org_ids = attach.op_right.who_has('self','read') - [@cur_user.org_id]

    solution.op_notice.add(notice_org_ids)
    solution.save

    brief = solution.brief
    brief.op_notice.add(notice_org_ids)
    brief.save

    attach.destroy

    redirect_to vendor_solution_path(solution)
  end

  def edit
    @attach = SolutionAttach.find(params[:id])
    @solution = @attach.solution
  end

  def update
    @attach = SolutionAttach.find(params[:id])
    @solution = @attach.solution
    invalid_op unless @attach.op_right.check('self',@cur_user.org_id,'update')

    attr = params[:solution_attach]
    if @attach.update_attributes(attr)
      notice_org_ids = @attach.op_right.who_has('self','read') - [@cur_user.org_id]
      @attach.op_notice.add(notice_org_ids)
      @attach.save

      @solution.op_notice.add(notice_org_ids)
      @solution.save

      brief = @solution.brief
      brief.op_notice.add(notice_org_ids)
      brief.save

      redirect_to vendor_solution_path(@solution)
    else
      render action: "edit" 
    end
  end

  def check
    value = 'y'
    if block_given?
      value = yield
    end

    attach = SolutionAttach.find(params[:id])
    #attach.can_checked_by?(@cur_user.org_id)
    attach.op_right.check('self',@cur_user.org_id,'check')
    attach.checked = value
    
    #notice_org_ids = attach.op_right.who_has('self','read') - [@cur_user.org_id]
    #attach.op_notice.add(notice_org_ids)
    
    attach.save
=begin
    solution = attach.solution
    solution.op_notice.add(notice_org_ids)
    solution.save

    brief = solution.brief
    brief.op_notice.add(notice_org_ids)
    brief.save
=end
    if params[:dest]
      redirect_to params[:dest]
    else
      redirect_to vendor_solution_path(attach.solution)
    end
  end

  def uncheck
    check{'n'}
  end
end
