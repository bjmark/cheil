class PaymentsController < ApplicationController
  before_filter :cur_user 

  # GET /payments
  # GET /payments.json
  def index
    @payments = Payment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @payments }
    end
  end

  # GET /payments/1
  # GET /payments/1.json
  def show
    @payment = Payment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @payment }
    end
  end

  # GET /payments/new
  # GET /payments/new.json
  def new
    @payment = Payment.new
    @payment.solution_id = params[:solution_id]
    @payment.org_id = params[:org_id]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @payment }
    end
  end

  # GET /payments/1/edit
  def edit
    @payment = Payment.find(params[:id])
  end

  # POST /payments
  # POST /payments.json
  def create
    @payment = Payment.new(params[:payment])

    if @payment.save
      redirect_to cheil_solution_path(@payment.solution_id), 
        notice: 'Payment was successfully created.' 
    else
      render action: "new" 
    end
  end

  # PUT /payments/1
  # PUT /payments/1.json
  def update
    @payment = Payment.find(params[:id])

    if @payment.update_attributes(params[:payment])
      redirect_to solution_path(@payment.solution_id), notice: 'Payment was successfully updated.' 
    else
      render action: "edit" 
    end
  end

  # DELETE /payments/1
  def destroy
    @payment = Payment.find(params[:id])
    @payment.destroy

    redirect_to cheil_solution_path(@payment.solution_id) 
  end
end
