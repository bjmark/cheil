# encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery

  def authorize(m_class,type)
    return false unless session[:user]=~/^#{type}/
      a=session[:user].split('_')
    return false if a.length != 2
    @cur_user = m_class.find_by_id(a[1].to_i)
  end

  def admin_authorize
    redirect_to admin_users_login_url unless authorize(AdminUser,'admin')
    @menu_file = 'admin_users/_menu'
  end

  def rpm_authorize
    redirect_to users_login_url unless authorize(User,'rpm')
    @menu_file = 'rpm/_menu'
  end

  def cheil_authorize
    redirect_to users_login_url unless authorize(User,'cheil')
    @menu_file = 'cheil/_menu'
  end

  def vendor_authorize
    redirect_to users_login_url unless authorize(User,'vendor')
    @menu_file = 'vendor/_menu'
  end

  def invalid_op
    raise SecurityError
  end
end
