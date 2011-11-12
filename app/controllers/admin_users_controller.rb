# encoding: utf-8
class AdminUsersController < ApplicationController
  before_filter :admin_authorize,:except=>[:login,:check]

  # GET /admin_users
  def index
    @admin_users = AdminUser.all
  end

  # GET /admin_users/1
  def show
    @admin_user = AdminUser.find(params[:id])
  end

  # GET /admin_users/new
  def new
    @admin_user = AdminUser.new
  end

  # GET /admin_users/1/edit
  def edit
    @admin_user = AdminUser.find(params[:id])
  end

  # POST /admin_users
  def create
    @admin_user = AdminUser.new(params[:admin_user])

    if @admin_user.save
      redirect_to @admin_user, notice: 'Admin user was successfully created.' 
    else
      render action: "new" 
    end
  end

  # PUT /admin_users/1
  def update
    @admin_user = AdminUser.find(params[:id])

    if @admin_user.update_attributes(params[:admin_user])
      redirect_to @admin_user, notice: 'Admin user was successfully updated.' 
    else
      render action: "edit" 
    end
  end

  # DELETE /admin_users/1
  def destroy
    @admin_user = AdminUser.find(params[:id])
    @admin_user.destroy
    redirect_to admin_users_url 
  end
end
