# encoding: utf-8
class AdminUsersController < ApplicationController
  before_filter :cur_user , :check_right

  def check_right
    case @cur_user
    when AdminUser then return
    else  raise SecurityError
    end
  end

  # GET /admin_users
  def index
    @admin_users = AdminUser.all
    render 'admin_users/index/show'
  end

  # GET /admin_users/1
  def show
    @admin_user = AdminUser.find(params[:id])
    render 'admin_users/show/show'
  end

  # GET /admin_users/new
  def new
    @admin_user = AdminUser.new
    @title = '新建管理员'
    render 'share/new_edit'
  end

  # GET /admin_users/1/edit
  def edit
    @admin_user = AdminUser.find(params[:id])
    @title = '修改管理员'
    render 'share/new_edit'
  end

  # POST /admin_users
  def create
    @admin_user = AdminUser.new(params[:admin_user])

    if @admin_user.save
      redirect_to admin_users_path, notice: 'Admin user was successfully created.' 
    else
      bread_pop!
      render 'share/new_edit' 
    end
  end

  # PUT /admin_users/1
  def update
    @admin_user = AdminUser.find(params[:id])

    if @admin_user.update_attributes(params[:admin_user])
      redirect_to admin_users_path, notice: 'Admin user was successfully updated.' 
    else
      bread_pop!
      render 'share/new_edit' 
    end
  end

  # DELETE /admin_users/1
  def destroy
    @admin_user = AdminUser.find(params[:id])
    @admin_user.destroy
    redirect_to admin_users_url 
  end
end
