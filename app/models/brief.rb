class Brief < ActiveRecord::Base
  belongs_to :rpm_org,:foreign_key => :rpm_id
  belongs_to :cheil_org,:foreign_key => :cheil_id
  belongs_to :user
  has_many :items
  has_many :comments,:class_name=>'BriefComment',:order=>'id desc'
  has_many :brief_vendors

  validates :name, :presence => true

  def designs
    items.find_all_by_kind('design')
  end

  def products
    items.find_all_by_kind('product')
  end

  def send_to_cheil?
    self.cheil_id > 0
  end

  def send_to_cheil!
    self.cheil_org = rpm_org.cheil_org
    save
  end
end
