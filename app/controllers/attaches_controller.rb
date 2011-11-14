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
    bread_pop!

    attach = Attach.find(params[:id])
    attach.check_read_right(@cur_user)

    send_file attach.attach.path,
      :filename => attach.attach_file_name,
      :content_type => attach.attach_content_type
  end

  #get 'briefs/:brief_id/attaches/new' => :new,
  #  :as => 'new_brief_attach'
  def new
    if params[:brief_id]
      @brief = Brief.find(params[:brief_id])
      @brief.check_edit_right(@cur_user)
      @path = brief_attaches_path(@brief,:dest=>bread_pre)
      @attach = BriefAttach.new
    end
    @title = '新附件'
    render 'share/new_edit'
  end

  def edit
    @attach = Attach.find(params[:id])
    @attach.check_update_right(@cur_user)
  end

  #post 'briefs/:brief_id/attaches' => :create,
  #  :as => 'brief_attachs'
  def create
    if params[:brief_id]
      @brief = Brief.find(params[:brief_id])
      @brief.check_edit_right(@cur_user)
      @attach = @brief.attaches.new(params[:brief_attach])

      if @attach.save
        redirect_to params[:dest]
      else
        @path = brief_attaches_path(@brief,:back=>@back)
        render :action => 'new'
      end
    end
  end

  def update
    @attach = Attach.find(params[:id])
    @attach.check_update_right(@cur_user)

    case @attach
    when BriefAttach 
      attr = params[:brief_attach]
      path = brief_path(@attach.fk_id)
    when SolutionAttach
      attr = params[:solution_attach]
      path = solution_path(@attach.fk_id)
    end

    if @attach.update_attributes(attr)
      redirect_to path
    else
      render action: "edit" 
    end
  end

  def destroy
    attach = Attach.find(params[:id])
    attach.check_update_right(@cur_user)

    case @attach
    when BriefAttach 
      path = brief_path(@attach.fk_id)
    when SolutionAttach
      path = solution_path(@attach.fk_id)
    end

    attach.destroy
    redirect_to path
  end
end
