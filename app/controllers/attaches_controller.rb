#encoding=utf-8
class AttachesController < ApplicationController
  before_filter :cur_user , :check_right

  def check_right
=begin
    case @cur_user.org
    when RpmOrg , CheilOrg
    else  raise SecurityError
    end
=end
  end

  def download
    attach = Attach.find(params[:id])
    attach.check_read_right(@cur_user)

    send_file attach.attach.path,
      :filename => attach.attach_file_name,
      :content_type => attach.attach_content_type
  end

  def owner_path(attach)
    case attach
    when BriefAttach 
      brief_path(attach.fk_id)
    when SolutionAttach
      solution_path(attach.fk_id)
    end
  end

  def new
    case 
    when params[:brief_id]
      brief = Brief.find(params[:brief_id])
      brief.check_edit_right(@cur_user)
      @attach = BriefAttach.new
      @path = attaches_path(:brief_id=>brief.id)
      @back = brief_path(brief)
    when params[:solution_id]
      solution = Solution.find(params[:solution_id])
      solution.check_edit_right(@cur_user)
      @attach = SolutionAttach.new
      @path = attaches_path(:solution_id=>solution.id)
      @back = solution_path(solution)
    end
  end

  def edit
    @attach = Attach.find(params[:id])
    @attach.check_update_right(@cur_user)
    @path = attach_path(@attach)
    @back = owner_path(@attach)
  end

  def create
    case
    when params[:brief_id]
      brief = Brief.find(params[:brief_id])
      brief.check_edit_right(@cur_user)
      @attach = brief.attaches.new(params[:brief_attach])
      @path = attaches_path(:brief_id=>brief.id)
    when params[:solution_id]
      solution = Solution.find(params[:solution_id])
      solution.check_edit_right(@cur_user)
      @attach = solution.attaches.new(params[:solution_attach])
      @path = attaches_path(:solution_id=>solution.id)
    end

    @back = owner_path(@attach)

    if @attach.save
      redirect_to @back 
    else
      render :action => 'new'
    end
  end

  def update
    @attach = Attach.find(params[:id])
    @attach.check_update_right(@cur_user)

    case @attach
    when BriefAttach 
      attr = params[:brief_attach]
    when SolutionAttach
      attr = params[:solution_attach]
    end

    @back = owner_path(@attach)

    if @attach.update_attributes(attr)
      redirect_to @back
    else
      render action: "edit" 
    end
  end

  def destroy
    attach = Attach.find(params[:id])
    attach.check_update_right(@cur_user)
    attach.destroy

    redirect_to owner_path(attach)
  end
end
