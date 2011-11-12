#encoding:utf-8
class SolutionItem < Item
  belongs_to :solution , :foreign_key => 'fk_id'
  belongs_to :brief_item , :foreign_key => 'parent_id'
end
