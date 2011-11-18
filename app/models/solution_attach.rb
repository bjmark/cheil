class SolutionAttach < Attach
  belongs_to :solution,:foreign_key => 'fk_id'

  def can_checked_by?(a_user)
    a_user.org.instance_of?(CheilOrg) and solution.can_read_by?(a_user) 
  end

end
