class Attach < ActiveRecord::Base
  has_attached_file :attach,:path => ":rails_root/attach_files/:id/:filename" 
  belongs_to :user
=begin
  def check_read_right(org_id)
    can_read_by?(org_id) or raise SecurityError
  end

  def check_update_right(org_id)
    can_update_by?(org_id) or raise SecurityError
  end

  def can_checked_by?(org_id)
    false
  end
=end
  def op
    @op ||= Cheil::Op.new(self) 
  end

  def op_right
    @op_right ||= Cheil::OpRight.new(self) 
  end

  def op_notice
    @op_notice ||= Cheil::OpNotice.new(self) 
  end
end
