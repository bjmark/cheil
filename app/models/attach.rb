class Attach < ActiveRecord::Base
  has_attached_file :attach,:path => ":rails_root/attach_files/:id/:filename" 

  def check_read_right(user)
  end

  def check_update_right(user)
  end

end
