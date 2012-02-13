#encoding:utf-8
class BriefItem < Item 
  belongs_to :brief , :foreign_key => 'fk_id'
  has_many :solution_items , :foreign_key => 'parent_id'

  # a is a solution or a solution_id
=begin 
  def del_from_solution(a)
    solution_id = a.instance_of?(Solution) ? a.id : a
    i = solution_items.find_by_fk_id(solution_id)
    i and i.destroy
  end
=end
  # a is a solution or a solution_id
=begin
  def add_to_solution(a)
    solution = a.instance_of?(Solution) ? a : Solution.find(a)
    solution.items.find_by_parent_id(self.id) and return
    solution.items.create(:parent_id=>self.id)
  end
=end
  def check_edit_right(_org_id)
    brief.check_edit_right(_org_id)
  end
end
