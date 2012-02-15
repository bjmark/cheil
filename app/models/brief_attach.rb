=begin
self:read,update,delete

rpm
self:read,update,delete

cheil
self:read,update,delete

vendor
self:read
=end

class BriefAttach < Attach
  belongs_to :brief,:foreign_key => 'fk_id'
end
