# encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery

  def cur_user
    begin
      break unless session[:user]
      a=session[:user].split('_')
      break if a.length != 2

      @cur_user = User.find(a[1].to_i)
      case @cur_user.org
      when RpmOrg then @menu_file = 'share/rpm_menu'
      when CheilOrg then @menu_file = 'share/cheil_menu'
      when VendorOrg then @menu_file = 'share/vendor_menu'
      end

      return
    end while false
    redirect_to users_login_url
  end

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

  def invalid_op
    raise SecurityError
  end
end
