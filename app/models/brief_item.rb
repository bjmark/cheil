#encoding:utf-8
class BriefItem < Item 
  belongs_to :brief , :foreign_key => 'fk_id'
  has_many :solution_items , :foreign_key => 'parent_id'
end
