class PayersController < ApplicationController
  before_filter :cur_user , :check_right

  def check_right
    case @cur_user
    when AdminUser then return
    else  raise SecurityError
    end
  end

  # GET /payers
  # GET /payers.json
  def index
    @payers = Payer.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @payers }
    end
  end

  # GET /payers/1
  # GET /payers/1.json
  def show
    @payer = Payer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @payer }
    end
  end

  # GET /payers/new
  # GET /payers/new.json
  def new
    @payer = Payer.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @payer }
    end
  end

  # GET /payers/1/edit
  def edit
    @payer = Payer.find(params[:id])
  end

  # POST /payers
  # POST /payers.json
  def create
    @payer = Payer.new(params[:payer])

    respond_to do |format|
      if @payer.save
        format.html { redirect_to payers_path, notice: 'Payer was successfully created.' }
        format.json { render json: @payer, status: :created, location: @payer }
      else
        format.html { render action: "new" }
        format.json { render json: @payer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /payers/1
  # PUT /payers/1.json
  def update
    @payer = Payer.find(params[:id])

    respond_to do |format|
      if @payer.update_attributes(params[:payer])
        format.html { redirect_to payers_path, notice: 'Payer was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @payer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payers/1
  # DELETE /payers/1.json
  def destroy
    @payer = Payer.find(params[:id])
    @payer.destroy

    respond_to do |format|
      format.html { redirect_to payers_url }
      format.json { head :ok }
    end
  end
end
