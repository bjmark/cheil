class LoginsController < ApplicationController
  before_filter :cur_user , :check_right

  def check_right
    case @cur_user
    when AdminUser then return
    else  raise SecurityError
    end
  end

  def index
    @logins = Login.order('id desc').page(params[:page])
  end
end
