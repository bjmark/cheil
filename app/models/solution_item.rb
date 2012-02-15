#encoding:utf-8
=begin
self:read,update,delete,check,price

cheil
self:read,check

vendor
self:read,delete,update,price

=end
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

  def changed_by(org_id)
    notice_ids = self.op_right.who_has('self','read') - [org_id]
    return if notice_ids.blank?

    self.op_notice.add(notice_ids)
    self.save

    solu = self.solution 
    solu.op_notice.add(notice_ids)
    solu.save

    brie = solu.brief
    brie.op_notice.add(notice_ids)
    brie.save
  end

  #计算并保存
  def cal_save
    total_up_f = quantity.to_f * price.to_f
    self.total_up = total_up_f.to_i.to_s

    tax_f = total_up_f * tax_rate.to_f
    self.tax = tax_f.to_i.to_s

    tt_f = total_up_f + tax_f
    self.total_up_tax = tt_f.to_i.to_s

    self.save
  end

end
