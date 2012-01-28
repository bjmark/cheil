#encoding=utf-8
class AttachesController < ApplicationController
  before_filter :cur_user 

  def download
    attach = Attach.find(params[:id])
    attach.check_read_right(@cur_user.org_id)

    attach.op.read_by(@cur_user.id)

    send_file attach.attach.path,
      :filename => attach.attach_file_name,
      :content_type => attach.attach_content_type
  end

  def owner_path(attach)
    case attach
    when BriefAttach 
      brief_path(attach.fk_id)
    when SolutionAttach
      vendor_solution_path(attach.fk_id)
    end
  end

  def new
    case 
    when params[:brief_id]
      brief = Brief.find(params[:brief_id])
      brief.check_edit_right(@cur_user.org_id)
      @attach = BriefAttach.new
      @path = attaches_path(:brief_id=>brief.id)
      @back = brief_path(brief)
    when params[:solution_id]
      solution = Solution.find(params[:solution_id])
      solution.check_edit_right(@cur_user.org_id)
      @attach = SolutionAttach.new
      @path = attaches_path(:solution_id=>solution.id)
      @back = vendor_solution_path(solution)
    end
  end

  def edit
    @attach = Attach.find(params[:id])
    @attach.check_update_right(@cur_user.org_id)
    @path = attach_path(@attach)
    @back = owner_path(@attach)
  end

  def create
    case
    when params[:brief_id]
      brief = Brief.find(params[:brief_id])
      brief.check_edit_right(@cur_user.org_id)
      
      brief.op.touch(@cur_user.id)
      
      @attach = brief.attaches.new(params[:brief_attach])
      @path = attaches_path(:brief_id=>brief.id)
    when params[:solution_id]
      solution = Solution.find(params[:solution_id])
      solution.check_edit_right(@cur_user.org_id)

      solution.op.touch(@cur_user.id)

      @attach = solution.attaches.new(params[:solution_attach])
      @path = attaches_path(:solution_id=>solution.id)
    end

    @back = owner_path(@attach)

    if @attach.op.save_by(@cur_user.id)
      redirect_to @back 
    else
      render :action => 'new'
    end
  end

  def check
    value = 'y'
    if block_given?
      value = yield
    end

    attach = SolutionAttach.find(params[:id])
    attach.can_checked_by?(@cur_user.org_id)
    attach.checked = value
    attach.save

    if params[:dest]
      redirect_to params[:dest]
    else
      redirect_to vendor_solution_path(attach.solution)
    end

  end

  def uncheck
    check{'n'}
  end

  def update
    @attach = Attach.find(params[:id])
    @attach.check_update_right(@cur_user.org_id)

    case @attach
    when BriefAttach 
      @attach.brief.op.touch(@cur_user.id)
      attr = params[:brief_attach]
    when SolutionAttach
      @attach.solution.op.touch(@cur_user.id)
      attr = params[:solution_attach]
    end

    @back = owner_path(@attach)

    if @attach.update_attributes(attr)
      @attach.op.save_by(@cur_user.id)
      redirect_to @back
    else
      render action: "edit" 
    end
  end

  def destroy
    attach = Attach.find(params[:id])
    attach.check_update_right(@cur_user.org_id)

    case attach
    when BriefAttach 
      attach.brief.op.touch(@cur_user.id)
    when SolutionAttach
      attach.solution.op.touch(@cur_user.id)
    end

    attach.destroy

    redirect_to owner_path(attach)
  end
end
