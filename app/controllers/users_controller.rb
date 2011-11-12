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
    render 'users/show/show'
  end

  # GET /users/new
  def new
    org = Org.find(params[:org_id])
    @user = org.users.build

    @title = '新建用户'
    render 'share/new_edit'
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    @title = '修改用户'
    render 'share/new_edit'
  end

  # POST /users
  def create
    @user = User.new(params[:user])

    bread_pop!
    if @user.save
      redirect_to bread_pre , notice: 'User was successfully created.' 
    else
      render 'share/new_edit'
    end
  end

  # PUT /users/1
  def update
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])
      redirect_to @user, notice: 'User was successfully updated.' 
    else
      render 'share/new_edit'
    end
  end

  # DELETE /users/1
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to bread_pre 
  end
end
