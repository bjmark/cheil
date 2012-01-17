class Solution < ActiveRecord::Base
  belongs_to :brief
  belongs_to :org
  has_many :items,:class_name=>'SolutionItem',:foreign_key=>'fk_id'
  has_many :attaches,:class_name=>'SolutionAttach',:foreign_key => 'fk_id'
  has_many :comments,
    :class_name=>'SolutionComment',:foreign_key=>'fk_id',:order=>'id desc'

  has_many :payments,:order=>'org_id'

  def check_approve_right(_org_id)
    raise SecurityError
  end

  def can_approved_by?(_org_id)
    false
  end

  def owned_by?(_org_id)
    org_id == _org_id
  end

  def items_from_brief(reload = false)
    @items_from_brief = nil if reload
    @items_from_brief and return @items_from_brief 

    ids = items.find_all{|e| e.parent_id > 0}.collect{|e| e.parent_id}
    @items_from_brief = Item.where(:id=>ids)
  end

  def designs_from_brief
    items_from_brief.find_all{|e| e.kind == 'design'}
  end

  def products_from_brief
    items_from_brief.find_all{|e| e.kind == 'product'}
  end

  def designs
    ids = designs_from_brief.collect{|e| e.id}
    items.where(:parent_id=>ids)
  end

  def products
    ids = products_from_brief.collect{|e| e.id}
    items.where(:parent_id=>ids)
  end

  def trans
    items.where(:kind=>'tran')
  end

  def others
    items.where(:kind=>'other')
  end

  def op
    @op ||= Cheil::Op.new(self) 
  end
end
