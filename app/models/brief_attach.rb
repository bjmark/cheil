class BriefAttach < Attach
  belongs_to :brief,:foreign_key => 'fk_id',:touch=>true

  def can_read_by?(org_id)
    brief.can_read_by?(org_id)
  end

  def can_update_by?(org_id)
    brief.can_edit_by?(org_id)
  end

end
