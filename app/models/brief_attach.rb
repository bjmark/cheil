class BriefAttach < Attach
  belongs_to :brief,:foreign_key => 'fk_id'

  def can_read?(u)
    return true if can_update?(u)
  end
end
