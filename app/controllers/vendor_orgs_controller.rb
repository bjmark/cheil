class VendorOrgsController < ApplicationController
  before_filter :admin_authorize

  # GET /vendor_orgs
  # GET /vendor_orgs.json
  def index
    @vendor_orgs = VendorOrg.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @vendor_orgs }
    end
  end

  # GET /vendor_orgs/1
  # GET /vendor_orgs/1.json
  def show
    @vendor_org = VendorOrg.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @vendor_org }
    end
  end

  # GET /vendor_orgs/new
  # GET /vendor_orgs/new.json
  def new
    @vendor_org = VendorOrg.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @vendor_org }
    end
  end

  # GET /vendor_orgs/1/edit
  def edit
    @vendor_org = VendorOrg.find(params[:id])
  end

  # POST /vendor_orgs
  # POST /vendor_orgs.json
  def create
    @vendor_org = VendorOrg.new(params[:vendor_org])

    respond_to do |format|
      if @vendor_org.save
        format.html { redirect_to @vendor_org, notice: 'Vendor org was successfully created.' }
        format.json { render json: @vendor_org, status: :created, location: @vendor_org }
      else
        format.html { render action: "new" }
        format.json { render json: @vendor_org.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /vendor_orgs/1
  # PUT /vendor_orgs/1.json
  def update
    @vendor_org = VendorOrg.find(params[:id])

    respond_to do |format|
      if @vendor_org.update_attributes(params[:vendor_org])
        format.html { redirect_to @vendor_org, notice: 'Vendor org was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @vendor_org.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vendor_orgs/1
  # DELETE /vendor_orgs/1.json
  def destroy
    @vendor_org = VendorOrg.find(params[:id])
    @vendor_org.destroy

    respond_to do |format|
      format.html { redirect_to vendor_orgs_url }
      format.json { head :ok }
    end
  end
end
