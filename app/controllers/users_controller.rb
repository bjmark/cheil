# encoding: utf-8
class UsersController < ApplicationController
  before_filter :admin_authorize,:except=>[:login,:check,:logout]

  #GET  /user/login
  def login
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @admin_user }
    end
  end

  # POST /users/login
  def check
    unless u = User.check_pass(params[:name],params[:password])
      redirect_to users_login_url
      return
    end
    case u.org.role
    when 'rpm' 
      session[:user] = "rpm_#{u.id}"
      redirect_to rpm_briefs_url
    when 'cheil'
      session[:user] = "cheil_#{u.id}"
      redirect_to cheil_briefs_url
    when 'vendor'
      session[:user] = "vendor_#{u.id}"
      redirect_to vendor_briefs_url
    end
  end

  #DELETE /user/logout
  def logout
    session[:user]=nil
    redirect_to users_login_path
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
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new
    @user.org_id = params[:org_id]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to orgs_path, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :ok }
    end
  end
end
