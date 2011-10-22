class BriefVendorsController < ApplicationController
  # GET /brief_vendors
  # GET /brief_vendors.json
  def index
    @brief_vendors = BriefVendor.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @brief_vendors }
    end
  end

  # GET /brief_vendors/1
  # GET /brief_vendors/1.json
  def show
    @brief_vendor = BriefVendor.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @brief_vendor }
    end
  end

  # GET /brief_vendors/new
  # GET /brief_vendors/new.json
  def new
    @brief_vendor = BriefVendor.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @brief_vendor }
    end
  end

  # GET /brief_vendors/1/edit
  def edit
    @brief_vendor = BriefVendor.find(params[:id])
  end

  # POST /brief_vendors
  # POST /brief_vendors.json
  def create
    @brief_vendor = BriefVendor.new(params[:brief_vendor])

    respond_to do |format|
      if @brief_vendor.save
        format.html { redirect_to @brief_vendor, notice: 'Brief vendor was successfully created.' }
        format.json { render json: @brief_vendor, status: :created, location: @brief_vendor }
      else
        format.html { render action: "new" }
        format.json { render json: @brief_vendor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /brief_vendors/1
  # PUT /brief_vendors/1.json
  def update
    @brief_vendor = BriefVendor.find(params[:id])

    respond_to do |format|
      if @brief_vendor.update_attributes(params[:brief_vendor])
        format.html { redirect_to @brief_vendor, notice: 'Brief vendor was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @brief_vendor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /brief_vendors/1
  # DELETE /brief_vendors/1.json
  def destroy
    @brief_vendor = BriefVendor.find(params[:id])
    @brief_vendor.destroy

    respond_to do |format|
      format.html { redirect_to brief_vendors_url }
      format.json { head :ok }
    end
  end
end
