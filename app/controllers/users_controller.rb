# encoding: utf-8
class UsersController < ApplicationController
  before_filter :cur_user , :check_right

  def check_right
    case @cur_user
    when AdminUser then return
    else  raise SecurityError
    end
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
    @user = User.find(params[:id])
    flash[:dest] = flash[:dest]
  end

  # GET /users/new
  def new
    org = Org.find(params[:org_id])
    flash[:dest] = flash[:dest]
    @user = org.users.build
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    @back = user_path(@user)
    flash[:dest] = flash[:dest]
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
    @user = User.find(params[:id])
    flash[:dest] = flash[:dest]

    if @user.update_attributes(params[:user])
      redirect_to @user, notice: 'User was successfully updated.' 
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
