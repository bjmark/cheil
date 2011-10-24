class BriefVendor < ActiveRecord::Base
  has_many :items
  belongs_to :brief

  def items_of(kind_name)
    items.find_all{|e|e.kind == kind_name}
  end

  def designs
    items_of('design')
  end

  def products
    items_of('product')
  end

  def trans_items
    items_of('trans')
  end

  def others
    items_of('other')
  end

  def items_total(kind_name)
    n = 0
    items_of(kind_name).each{|e| n += e.total}
    return n
  end

  def design_total
    items_total('design')
  end

  def product_total
    items_total('product')
  end

  def trans_total
    items_total('trans')
  end

  def other_total
    items_total('other')
  end
end
