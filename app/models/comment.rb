class Comment < ActiveRecord::Base
  belongs_to :user

  def check_destroy_right(user)
    raise SecurityError if user_id != user.id 
  end
end

