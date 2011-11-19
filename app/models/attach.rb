class Attach < ActiveRecord::Base
  has_attached_file :attach,:path => ":rails_root/attach_files/:id/:filename" 
  belongs_to :user

  def can_update_by?(u)
    user.org_id == u.org_id
  end

  def check_read_right(user)
  end

  def check_update_right(user)
  end

  def can_checked_by?(a_user)
    return false
  end
end
