class SolutionAttach < Attach
  belongs_to :solution,:foreign_key => 'fk_id'
end
