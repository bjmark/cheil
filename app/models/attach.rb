class Attach < ActiveRecord::Base
  has_attached_file :attach,:path => ":rails_root/attach_files/:id/:filename" 
  belongs_to :user

  def check_read_right(org_id)
    can_read_by?(org_id) or raise SecurityError
  end

  def check_update_right(org_id)
    can_update_by?(org_id) or raise SecurityError
  end

  def can_checked_by?(org_id)
    false
  end
end
