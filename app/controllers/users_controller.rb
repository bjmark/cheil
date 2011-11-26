# encoding: utf-8
class UsersController < ApplicationController
  before_filter :cur_user , :check_right

  def check_right
    ok = case @cur_user
    when AdminUser then true
    else      
      %w{show edit update}.include?(params[:action]) and params[:id] == 'cur'
    end
    ok or (raise SecurityError)
  end

  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  def show
    case 
    when params[:id] == 'cur'
      @user = @cur_user
      render 'show_cur'
    else
      @user = User.find(params[:id])
      flash[:dest] = flash[:dest]
    end
  end

  # GET /users/new
  def new
    org = Org.find(params[:org_id])
    flash[:dest] = flash[:dest]
    @user = org.users.build
  end

  # GET /users/1/edit
  def edit
    case 
    when params[:id] == 'cur'
      @user = @cur_user
      render 'edit_cur'
    else
      @user = User.find(params[:id])
      @back = user_path(@user)
      flash[:dest] = flash[:dest]
    end
  end

  # POST /users
  def create
    @user = User.new(params[:user])

    if @user.save
      redirect_to flash[:dest] , notice: 'User was successfully created.' 
    else
      render :action=>:new
    end
  end

  # PUT /users/1
  def update
    case params[:id]
    when 'cur'
      @user = User.find(@cur_user.id)
    else
      @user = User.find(params[:id])
      flash[:dest] = flash[:dest]
    end

    if @user.update_attributes(params[:user])
      redirect_to user_path(params[:id]), notice: 'User was successfully updated.' 
    else
      @back = user_path(@user)
      render :action=>:edit
    end
  end

  # DELETE /users/1
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to flash[:dest] 
  end
end
