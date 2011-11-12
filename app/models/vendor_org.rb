#encoding=utf-8
class VendorOrg < Org 
  has_many :users , :foreign_key => :org_id
  has_many :brief_vendors , :foreign_key => :org_id

  def self.nav_partial
    'share/vendor_menu'
  end

  def self.type_name
    'Vendor'
  end

  def nav_links
    [['项目列表', '/briefs']]
  end
end
