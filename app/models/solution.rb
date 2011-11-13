class Solution < ActiveRecord::Base
  belongs_to :brief
  belongs_to :org
  has_many :items,:class_name=>'SolutionItem',:foreign_key=>'fk_id'
end
