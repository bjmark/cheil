#encoding=utf-8
class RpmOrgsController < ApplicationController
  before_filter :admin_authorize

  # GET /orgs
  # GET /orgs.json
  def index
    @rpm_orgs = RpmOrg.all
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
  # GET /orgs/new.json
  def new
    @rpm_org = RpmOrg.new
  end

  # GET /orgs/1/edit
  def edit
    @rpm_org = RpmOrg.find(params[:id])
  end

  # POST /orgs
  # POST /orgs.json
  def create
    name = params[:rpm_org][:name]
    @rpm_org = RpmOrg.new(:name=>name)

    respond_to do |format|
      if @rpm_org.save
        #建对应的cheil
        @rpm_org.cheil_org = CheilOrg.new(:name=>name)
        format.html { redirect_to @rpm_org, notice: 'RpmOrg was successfully created.' }
        format.json { render json: @org, status: :created, location: @org }
      else
        format.html { render action: "new" }
        format.json { render json: @org.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /orgs/1
  # PUT /orgs/1.json
  def update
    @rpm_org = RpmOrg.find(params[:id])

    respond_to do |format|
      if @rpm_org.update_attributes(params[:rpm_org])
        @rpm_org.cheil_org.update_attributes(:name=>@rpm_org.name)
        format.html { redirect_to @rpm_org, notice: 'Org was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @org.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orgs/1
  # DELETE /orgs/1.json
  def destroy
    @rpm_org = RpmOrg.find(params[:id])
    @rpm_org.destroy

    respond_to do |format|
      format.html { redirect_to rpm_orgs_url }
      format.json { head :ok }
    end
  end
end
