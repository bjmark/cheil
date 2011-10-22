class BriefVendor < ActiveRecord::Base
  has_many :items
  belongs_to :brief

  def designs
    items_of('design')
  end

  def items_of(kind_name)
    items.find_all do |e| 
      if e.parent_id > 0 
        e.parent_item.kind == kind_name
      else
        e.kind == kind_name
      end
    end
  end

  def products
    items_of('product')
  end

  def trans_item
    items_of('transport')
  end

  def others
    items_of('other')
  end

end
