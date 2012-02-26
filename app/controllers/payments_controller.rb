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
    @solution = CheilSolution.find(params[:solution_id])
    invalid_op if @solution.org_id != @cur_user.org_id
    @vendor = Org.find(params[:org_id])

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
    @solution = @payment.solution
    invalid_op if @solution.org_id != @cur_user.org_id
    @vendor = @payment.org
  end

  # POST /payments
  # POST /payments.json
  def create
    cheil_solution = CheilSolution.find(params[:payment][:solution_id])
    invalid_op if cheil_solution.org_id != @cur_user.org_id

    @payment = Payment.new(params[:payment])
    if @payment.save
      brief = cheil_solution.brief
      vendor_solution = brief.vendor_solutions.where(:org_id=>@payment.org_id).first
      vendor_solution.cal_pay 
      vendor_solution.save

      cheil_solution.cal_pay
      cheil_solution.save

      redirect_to payment_cheil_solution_path(cheil_solution) 
    else
      render action: "new" 
    end
  end

  # PUT /payments/1
  # PUT /payments/1.json
  def update
    @payment = Payment.find(params[:id])
    cheil_solution = @payment.solution
    invalid_op if cheil_solution.org_id != @cur_user.org_id

    if @payment.update_attributes(params[:payment])
      brief = cheil_solution.brief
      vendor_solution = brief.vendor_solutions.where(:org_id=>@payment.org_id).first
      vendor_solution.cal_pay 
      vendor_solution.save

      cheil_solution.cal_pay
      cheil_solution.save

      redirect_to payment_cheil_solution_path(cheil_solution)
    else
      render action: "edit" 
    end
  end

  # DELETE /payments/1
  def destroy
    @payment = Payment.find(params[:id])
    cheil_solution = @payment.solution
    invalid_op if cheil_solution.org_id != @cur_user.org_id

    @payment.destroy

    brief = cheil_solution.brief
    vendor_solution = brief.vendor_solutions.where(:org_id=>@payment.org_id).first
    vendor_solution.cal_pay 
    vendor_solution.save

    cheil_solution.cal_pay
    cheil_solution.save

    redirect_to payment_cheil_solution_path(@payment.solution_id) 
  end
end
