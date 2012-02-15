#encoding:utf-8
=begin
self:read,update,delete

rpm
self:read,update,delete

cheil
self:read,update,delete

vendor
self:read
=end

class BriefItem < Item 
  belongs_to :brief , :foreign_key => 'fk_id'
  has_many :solution_items , :foreign_key => 'parent_id'
end
