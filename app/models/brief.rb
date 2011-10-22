class Brief < ActiveRecord::Base
  belongs_to :org
  belongs_to :user
  has_many :items
  has_many :comments,:class_name=>'BriefComment',:order=>'id'
  has_many :brief_vendors

  def designs
    items.find_all_by_kind('design')
  end

  def products
    items.find_all_by_kind('product')
  end

  def send_to_cheil?
    self.send_to_cheil == 'y'
  end
end
