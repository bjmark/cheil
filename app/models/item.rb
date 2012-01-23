#encoding:utf-8
class Item < ActiveRecord::Base
  #item分两种情况
  #1.belongs to brief
  #2.belongs to brief_vendor,in this case,name,quantity,kind must take from his parent if it has a parent.
  #it has a parent if parent_id > 0
  #it has no parent if parent_id ==0

  validates_presence_of :name, :message=>'不可为空'

  scope :checked, where(:checked=>'y')

  KIND = {
    'design' => '设计项',
    'product'=> '制造项',
    'tran' => '运输项',
    'other' => '其他项'
  }

  def self.kind_cn(en)
    KIND[en]
  end

  def total
    a1 = quantity.to_f * price.to_f
    a2 = a1.to_i 
    a1 = a2 if a1 == a2
    return a1
  end
    
  def checked?
    checked == 'y'
  end

  def belongs_to?(a_solution)
    a_solution.items.find{|e| e.id == id or e.parent_id == id}
  end

  def op
    @op ||= Cheil::Op.new(self) 
  end
end
