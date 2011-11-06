#encoding:utf-8
class BriefItem < Item 
  belongs_to :brief,:foreign_key => 'fk_id'
end
