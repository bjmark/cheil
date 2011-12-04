#encoding=utf-8
class VendorOrgsController < ApplicationController
  before_filter :cur_user , :check_right

  def check_right
=begin
    case @cur_user
    when AdminUser then return
    else  raise SecurityError
    end
=end
  end

  # GET /vendor_orgs
  def index
    case
    when params[:brief_id]
      #已被选中的vendors
      @brief = Brief.find(params[:brief_id])
      bv = @brief.vendor_solutions
      #所有org去除已被选中的vendor
      @vendors = VendorOrg.all.reject do |e| 
        bv.find{|t| t.org_id == e.id}
      end

      @path = solutions_path(:brief_id=>@brief.id)
      @back = solutions_path(:brief_id=>@brief.id)

      render 'vendor_orgs/sel/index' 
    else
      @vendor_orgs = VendorOrg.all
      flash[:dest] = vendor_orgs_path
    end
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
  end

  # GET /vendor_orgs/1/edit
  def edit
    @vendor_org = VendorOrg.find(params[:id])
  end

  # POST /vendor_orgs
  def create
    @vendor_org = VendorOrg.new(params[:vendor_org])

    if @vendor_org.save
      redirect_to vendor_orgs_path, notice: 'Vendor org was successfully created.' 
    else
      render :action => :new
    end
  end

  # PUT /vendor_orgs/1
  def update
    @vendor_org = VendorOrg.find(params[:id])

    if @vendor_org.update_attributes(params[:vendor_org])
      redirect_to vendor_orgs_path, notice: 'Vendor org was successfully updated.' 
    else
      render :action=>:edit
    end
  end

  # DELETE /vendor_orgs/1
  def destroy
    @vendor_org = VendorOrg.find(params[:id])
    @vendor_org.destroy

    redirect_to vendor_orgs_url 
  end
end
