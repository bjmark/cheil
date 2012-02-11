#encoding=utf-8
class Comment < ActiveRecord::Base
  validates_presence_of :content,:message=>'不可为空'

  belongs_to :user

  def check_destroy_right(a_user)
    return true if can_del_by?(a_user)
    raise SecurityError  
  end
  
  def can_del_by?(a_user)
    user_id == a_user.id
  end

  def op_right
    @op_right ||= Cheil::OpRight.new(self) 
  end

  def op_notice
    @op_notice ||= Cheil::OpNotice.new(self) 
  end
end

