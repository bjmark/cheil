#encoding=utf-8
class VendorOrgsController < ApplicationController
  before_filter :cur_user , :check_right

  def check_right
    case @cur_user
    when AdminUser then return
    else  raise SecurityError
    end
  end

  # GET /vendor_orgs
  def index
    @vendor_orgs = VendorOrg.all
    render 'vendor_orgs/index/show'
  end

  # GET /vendor_orgs/1
  def show
    @vendor_org = VendorOrg.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @vendor_org }
    end
  end

  # GET /vendor_orgs/new
  def new
    @vendor_org = VendorOrg.new

    @title = '新建Vendor'
    render 'share/new_edit'
  end

  # GET /vendor_orgs/1/edit
  def edit
    @vendor_org = VendorOrg.find(params[:id])
    @title = '修改Vendor'
    render 'share/new_edit'
  end

  # POST /vendor_orgs
  def create
    @vendor_org = VendorOrg.new(params[:vendor_org])

    if @vendor_org.save
      redirect_to vendor_orgs_path, notice: 'Vendor org was successfully created.' 
    else
      @title = '新建RPM'
      render 'share/new_edit'
    end
  end

  # PUT /vendor_orgs/1
  def update
    @vendor_org = VendorOrg.find(params[:id])

    if @vendor_org.update_attributes(params[:vendor_org])
      redirect_to vendor_orgs_path, notice: 'Vendor org was successfully updated.' 
    else
      @title = '修改Vendor'
      render 'share/new_edit'
    end
  end

  # DELETE /vendor_orgs/1
  def destroy
    @vendor_org = VendorOrg.find(params[:id])
    @vendor_org.destroy

    redirect_to vendor_orgs_url 
  end
end
