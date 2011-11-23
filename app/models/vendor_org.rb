#encoding=utf-8
class VendorOrg < Org 
  def self.nav_partial
    'share/vendor_menu'
  end

  def self.type_name
    'Vendor'
  end

  def nav_links
    [['项目列表', '/briefs']]
  end

  def briefs
    brief_ids = solutions.collect{|e| e.brief_id}
    Brief.where(:id=>brief_ids)
  end
end
