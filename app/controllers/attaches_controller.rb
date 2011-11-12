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

  #get 'briefs/:brief_id/attaches/download' => :download,
  #  :as => 'download_brief_attach'
  def download
    bread_pop!
    if params[:brief_id]
      @brief = Brief.find(params[:brief_id])
      @brief.check_read_right(@cur_user)
      attach = @brief.attaches.find(params[:id])

      send_file attach.attach.path,
        :filename => attach.attach_file_name,
        :content_type => attach.attach_content_type
    end
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

  #get 'briefs/:brief_id/attaches/:id/edit' => :edit,
  #  :as => 'edit_brief_attach'
  def edit
    if params[:brief_id]
      @brief = Brief.find(params[:brief_id])
      @brief.check_edit_right(@cur_user)
      @attach = @brief.attaches.find(params[:id])
      @path = brief_attach_path(@brief,@attach,:dest=>bread_pre)
    end
    @title = '更新附件'
    render 'share/new_edit'
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

  #put 'briefs/:brief_id/attaches/:id' => :update,
  #  :as => 'brief_attach'
  def update
    if params[:brief_id]
      @brief = Brief.find(params[:brief_id])
      @brief.check_edit_right(@cur_user)
      @attach = @brief.attaches.find(params[:id])

      if @attach.update_attributes(params[:brief_attach])
        redirect_to params[:dest]
      else
        render action: "edit" 
      end
    end
  end

  #delete 'briefs/:brief_id/attaches/:id' => :destroy,
  #  :as => 'brief_attach'
  def destroy
    if params[:brief_id]
      @brief = Brief.find(params[:brief_id])
      @brief.check_edit_right(@cur_user)
      @attach = @brief.attaches.find(params[:id])
      @attach.destroy

      redirect_to bread_pre
    end
  end
end
