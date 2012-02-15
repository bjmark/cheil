=begin
self:read,delete

rpm
self:read,delete

cheil
self:read,delete
=end

class BriefComment < Comment
  belongs_to :brief,:foreign_key => 'fk_id'
end
