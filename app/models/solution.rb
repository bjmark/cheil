class Solution < ActiveRecord::Base
  has_many :items,:class_name=>'SolutionItem',:foreign_key=>'fk_id'
end
