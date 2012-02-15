=begin
self:read,delete

cheil
self:read,delete

vendor:read,delete
=end
class SolutionComment < Comment
  belongs_to :solution,:foreign_key => 'fk_id'
end
