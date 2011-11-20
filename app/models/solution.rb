class Solution < ActiveRecord::Base
  belongs_to :brief
  belongs_to :org
  has_many :items,:class_name=>'SolutionItem',:foreign_key=>'fk_id'
  has_many :attaches,:class_name=>'SolutionAttach',:foreign_key => 'fk_id'
  has_many :comments,
    :class_name=>'SolutionComment',:foreign_key=>'fk_id',:order=>'id desc'

  def check_read_right(a_user)
    return true if can_read_by?(a_user)
    raise SecurityError
  end

  alias :check_comment_right :check_read_right

  def check_edit_right(a_user)
    return true if can_edit_by?(a_user)
    raise SecurityError
  end

  def can_read_by?(a_user)
    return true if can_edit_by?(a_user)
    return true if assigned_by?(a_user)
  end

  alias :can_commented_by? :can_read_by?

  def can_edit_by?(a_user)
    owned_by?(a_user) 
  end

  def owned_by?(a_user)
    org_id == a_user.org_id
  end

  def assigned_by?(a_user)
    brief.received_by?(a_user.org)
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
    #items.find_all_by_kind('tran')
    items.where(:kind=>'tran')
  end

  def others
    #items.find_all_by_kind('other')
    items.where(:kind=>'other')
  end

  end
