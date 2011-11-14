class Solution < ActiveRecord::Base
  belongs_to :brief
  belongs_to :org
  has_many :items,:class_name=>'SolutionItem',:foreign_key=>'fk_id'

  def check_read_right(user)
    return true if owner?(user)
    raise SecurityError
  end

  def owner?(user)
    org_id == user.org_id
  end
end
