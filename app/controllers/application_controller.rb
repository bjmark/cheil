# encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery

  def cur_user
    (redirect_to new_session_path and return) unless session[:user_id]
    @cur_user = User.find(session[:user_id])
    bread_push!(request.fullpath)
    @sidebar = ['share/nav','share/cur_user']
  end

  def bread
    (session[:bread] or '').split(':')
  end

  def bread= (a)
    session[:bread] = a.join(':')
  end

  def bread_push!(path)
    a = []
    b = bread
    b.each do |e|
      if e.split('?')[0] == path.split('?')[0]
        break
      else
        a << e
      end
    end

    a.push(path)
    self.bread = a
  end

  def bread_pop!
    a = bread
    a.pop
    self.bread = a
  end

  def bread_last
    bread.last
  end

  def bread_pre
    bread[bread.length-2]
  end

  def invalid_op
    raise SecurityError
  end
end
