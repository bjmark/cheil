=begin
self:read,update,delete,check

cheil
self:read,check

vendor
self:read,update,delete
=end

class SolutionAttach < Attach
  belongs_to :solution,:foreign_key => 'fk_id'

  def can_checked_by?(org_id)
    solution.assigned_by?(org_id)
  end

  def check_read_right(org_id)
    solution.check_read_right(org_id)
  end

  def check_update_right(org_id)
    solution.check_edit_right(org_id)
  end
end
