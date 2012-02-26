class Solution < ActiveRecord::Base
  belongs_to :brief
  belongs_to :org
  has_many :items,:class_name=>'SolutionItem',:foreign_key=>'fk_id'
  has_many :attaches,:class_name=>'SolutionAttach',:foreign_key => 'fk_id'
  has_many :comments,:class_name=>'SolutionComment',:foreign_key=>'fk_id',:order=>'id desc'

  has_many :payments,:order=>'org_id'

  def designs
    items.find_all{|e| e.kind == 'design'}
  end

  def products
    items.find_all{|e| e.kind == 'product'}
  end

  def trans
    items.find_all{|e| e.kind == 'tran'}
  end

  def others
    items.find_all{|e| e.kind == 'other'}
  end

  def op
    @op ||= Cheil::Op.new(self) 
  end

  def op_right
    @op_right ||= Cheil::OpRight.new(self) 
  end

  def op_notice
    @op_notice ||= Cheil::OpNotice.new(self) 
  end
end
