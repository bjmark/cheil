# encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery

  def admin_authorize
    begin
      break unless session[:user]=~/^admin/
        a=session[:user].split('_')
      break if a.length != 2
      if @cur_user = AdminUser.find_by_id(a[1].to_i)
        @menu_file = 'admin_users/menu' 
        return 
      end
    end while false
    redirect_to admin_users_login_url
  end

  def rpm_authorize
    begin
      break unless session[:user]=~/^rpm/
        a=session[:user].split('_')
      break if a.length != 2
      if @cur_user = User.find_by_id(a[1].to_i)
        @menu_file = 'rpm/menu' 
        return 
      end
    end while false
    redirect_to users_login_url
  end

  def cheil_authorize
    begin
      break unless session[:user]=~/^cheil/
        a=session[:user].split('_')
      break if a.length != 2
      if @cur_user = User.find_by_id(a[1].to_i)
        @menu_file = 'cheil/menu' 
        return 
      end
    end while false
    redirect_to users_login_url
  end

   def vendor_authorize
    begin
      break unless session[:user]=~/^vendor/
      a=session[:user].split('_')
      break if a.length != 2
      if @cur_user = User.find_by_id(a[1].to_i)
        @menu_file = 'vendor/menu' 
        return 
      end
    end while false
    redirect_to users_login_url
  end

   def invalid_op
     raise SecurityError
   end
end
