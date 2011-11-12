#encoding=utf-8
class SessionsController < ApplicationController
  def new
    render 'new',:layout=>'sign'
  end

  def create
    unless u = User.check_pass(params[:name],params[:password])
      redirect_to new_session_path, notice: '用户名或密码错误.'
      return
    end
    
    session[:user_id] = u.id
    redirect_to u.home
  end

  def destroy
    session.clear
    redirect_to new_session_path
  end
end
