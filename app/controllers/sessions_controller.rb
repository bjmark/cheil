#encoding=utf-8
class SessionsController < ApplicationController
  def new
    render 'new',:layout=>'sign'
  end

  def create
    unless u = User.check_pass(params[:name],params[:password])
      redirect_to new_session_path, alert: '用户名或密码错误.' 
    else
      session[:user_id] = u.id
      login = Login.create(
        :name=>u.name,
        :ip=>request.remote_ip,
        :login_time=>Time.now
      )
      session[:login_id] = login.id
      redirect_to u.home
    end
  end

  def destroy
    if session[:login_id]
      login = Login.find(session[:login_id])
      login.is_logout = 'y'
      login.logout_time = Time.now
      login.save
    end
    session.clear
    redirect_to new_session_path
  end
end
