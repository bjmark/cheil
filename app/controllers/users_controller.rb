# encoding: utf-8
class UsersController < ApplicationController
  before_filter :admin_authorize,:except=>[:login,:check,:logout]

  def login
    render 'login',:layout=>'sign'
  end
  # POST /users/login
  def check
    unless u = User.check_pass(params[:name],params[:password])
      redirect_to users_login_url
      return
    end

    case u.org
    when RpmOrg 
      session[:user] = "rpm_#{u.id}"
    when CheilOrg
      session[:user] = "cheil_#{u.id}"
    when VendorOrg
      session[:user] = "vendor_#{u.id}"
    end
    
    redirect_to briefs_path
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

  def back_path(org)
    case org
    when RpmOrg then rpm_orgs_path
    when CheilOrg then cheil_orgs_path
    when VendorOrg then vendor_orgs_path
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    @back_path = back_path(@user.org)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    org = Org.find(params[:org_id])
    @user = org.users.build
    @back_path = back_path(org)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    @back_path = back_path(@user.org)
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to back_path(@user.org), notice: 'User was successfully created.' }
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
        format.html { redirect_to back_path(@user.org), notice: 'User was successfully updated.' }
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
    back = back_path(@user.org)
    @user.destroy

    respond_to do |format|
      format.html { redirect_to back }
      format.json { head :ok }
    end
  end
end
