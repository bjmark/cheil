# encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery

  def cur_user
    (redirect_to(new_session_path,:alert=>"请先登录") and return) unless session[:user_id]
    @cur_user = User.find(session[:user_id])
    @sidebar = ['share/nav','share/cur_user']
  end

  def invalid_op
    raise SecurityError
  end
end
