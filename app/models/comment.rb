class Comment < ActiveRecord::Base
  def check_destroy_right(user)
    raise SecurityError if user_id != user.id 
  end
end

