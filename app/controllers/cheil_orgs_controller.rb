class CheilOrgsController < ApplicationController
  before_filter :cur_user , :check_right

  def check_right
    case @cur_user
    when AdminUser then return
    else  raise SecurityError
    end
  end

  # GET /cheil_orgs
  def index
    @cheil_orgs = CheilOrg.all
    flash[:dest] = cheil_orgs_path
  end

  # GET /cheil_orgs/1
  # GET /cheil_orgs/1.json
  def show
    @cheil_org = CheilOrg.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @cheil_org }
    end
  end

  # GET /cheil_orgs/new
  # GET /cheil_orgs/new.json
  def new
    @cheil_org = CheilOrg.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @cheil_org }
    end
  end

  # GET /cheil_orgs/1/edit
  def edit
    @cheil_org = CheilOrg.find(params[:id])
  end

  # POST /cheil_orgs
  # POST /cheil_orgs.json
  def create
    @cheil_org = CheilOrg.new(params[:cheil_org])

    respond_to do |format|
      if @cheil_org.save
        format.html { redirect_to @cheil_org, notice: 'Cheil org was successfully created.' }
        format.json { render json: @cheil_org, status: :created, location: @cheil_org }
      else
        format.html { render action: "new" }
        format.json { render json: @cheil_org.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /cheil_orgs/1
  # PUT /cheil_orgs/1.json
  def update
    @cheil_org = CheilOrg.find(params[:id])

    respond_to do |format|
      if @cheil_org.update_attributes(params[:cheil_org])
        format.html { redirect_to @cheil_org, notice: 'Cheil org was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @cheil_org.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cheil_orgs/1
  # DELETE /cheil_orgs/1.json
  def destroy
    @cheil_org = CheilOrg.find(params[:id])
    @cheil_org.destroy

    respond_to do |format|
      format.html { redirect_to cheil_orgs_url }
      format.json { head :ok }
    end
  end
end
