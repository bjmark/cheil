class Solution < ActiveRecord::Base
  belongs_to :brief
  belongs_to :org
  has_many :items,:class_name=>'SolutionItem',:foreign_key=>'fk_id'
  has_many :attaches,:class_name=>'SolutionAttach',:foreign_key => 'fk_id'

  def check_read_right(user)
    return true if owner?(user)
    raise SecurityError
  end

  def can_read_by?(a_user)
    return true if can_edit_by?(a_user)
  end

  def can_edit_by?(a_user)
    owned_by?(a_user)
  end

  def owned_by?(a_user)
    org_id == user.org_id
  end

  def assigned_by?(a_user)
    brief.received_by?(a_user.org)
  end
end
