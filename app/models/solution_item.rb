#encoding:utf-8
class SolutionItem < Item
  belongs_to :solution , :foreign_key => 'fk_id'
  belongs_to :brief_item , :foreign_key => 'parent_id'

  def has_parent?
    parent_id > 0
  end

  def name
    return brief_item.name if has_parent?
    read_attribute(:name)
  end

  def quantity
    return brief_item.quantity if has_parent?
    read_attribute(:quantity)
  end

  def kind
    return brief_item.kind if has_parent?
    read_attribute(:kind)
  end

  def check_edit_right(_org_id)
    solution.check_edit_right(_org_id)
  end
end
