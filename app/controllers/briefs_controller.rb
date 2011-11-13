#encoding=utf-8
class BriefsController < ApplicationController
  before_filter :cur_user , :check_right

  def check_right
    rpm =[:index,:new,:show,:edit,:create,:update,:destroy,:send]
    cheil = [:index,:show]
    vendor = [:index,:show]

    case @cur_user.org
    when RpmOrg then rpm.include?(params[:action].to_sym)
    when CheilOrg then cheil.include?(params[:action].to_sym)
    when VendorOrg then vendor.include?(params[:action].to_sym)
    else  raise SecurityError
    end
  end

  # GET /briefs
  def index
    #@briefs = @cur_user.org.briefs.paginate(:page => params[:page])
    @briefs = @cur_user.org.briefs

  end

  # GET /briefs/1
  def show
    @brief = Brief.find(params[:id])
    @brief.check_read_right(@cur_user)
    case @cur_user.org
    when RpmOrg
      render 'briefs/rpm/show'
    when CheilOrg
      render 'briefs/cheil/show'
    when VendorOrg
      render 'briefs/vendor/show'
    end
  end

  # GET /briefs/new
  def new
    @brief = Brief.new
    @title = '新建 brief'
    render 'share/new_edit'
  end

  # GET /briefs/1/edit
  def edit
    @brief = Brief.find(params[:id])
    @brief.check_edit_right(@cur_user)
    @title = '修改 brief'
    render 'share/new_edit'
  end

  # POST /briefs
  def create
    @brief = Brief.new(params[:brief])
    @brief.rpm_id = @cur_user.org_id
    @brief.user_id = @cur_user.id

    if @brief.save
      redirect_to briefs_path, notice: 'Brief was successfully created.' 
    else
      render action: "new_edit" 
    end
  end

  # PUT /briefs/1
  # PUT /briefs/1.json
  def update
    @brief = Brief.find(params[:id])
    @brief.check_edit_right(@cur_user)

    if @brief.update_attributes(params[:brief])
      redirect_to @brief, notice: 'Brief was successfully updated.' 
    else
      render action: "edit" 
    end
  end

  # DELETE /briefs/1
  # DELETE /briefs/1.json
  def destroy
    @brief = Brief.find(params[:id])
    @brief.check_destroy_right(@cur_user)
    @brief.destroy
    redirect_to briefs_url,notice: 'Brief was successfully deleted.' 
  end

  #put /briefs/1/send_to_cheil
  def send_to_cheil
    @brief = Brief.find(params[:id])
    @brief.check_edit_right(@cur_user)
    @brief.send_to_cheil!
    redirect_to(brief_path(@brief),:notice=>'成功发送到cheil') 
  end
end
