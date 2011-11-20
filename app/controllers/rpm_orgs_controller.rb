#encoding=utf-8
class RpmOrgsController < ApplicationController
  before_filter :cur_user , :check_right

  def check_right
    case @cur_user
    when AdminUser then return
    else  raise SecurityError
    end
  end

  # GET /orgs
  # GET /orgs.json
  def index
    @rpm_orgs = RpmOrg.all
    flash[:dest] = rpm_orgs_path
  end

  # GET /orgs/1
  # GET /orgs/1.json
  def show
    @rpm_org = RpmOrg.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @org }
    end
  end

  # GET /orgs/new
  def new
    @rpm_org = RpmOrg.new
    @back = rpm_orgs_path
  end

  # GET /orgs/1/edit
  def edit
    @rpm_org = RpmOrg.find(params[:id])
    @back = rpm_orgs_path
  end

  # POST /orgs
  def create
    name = params[:rpm_org][:name]
    @rpm_org = RpmOrg.new(:name=>name)

    if @rpm_org.save
      #建对应的cheil
      @rpm_org.cheil_org = CheilOrg.new(:name=>name)
      redirect_to rpm_orgs_path, notice: 'RpmOrg was successfully created.' 
    else
      render :action=>:new 
    end
  end

  # PUT /orgs/1
  def update
    @rpm_org = RpmOrg.find(params[:id])

    if @rpm_org.update_attributes(params[:rpm_org])
      @rpm_org.cheil_org.update_attributes(:name=>@rpm_org.name)
      redirect_to rpm_orgs_path, notice: 'Org was successfully updated.' 
    else
      render :action=>:edit 
    end
  end

  # DELETE /orgs/1
  def destroy
    @rpm_org = RpmOrg.find(params[:id])
    @rpm_org.destroy

    redirect_to rpm_orgs_url 
  end
end
