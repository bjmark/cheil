class VendorOrg < Org 
  has_many :users , :foreign_key => :org_id
  has_many :brief_vendors , :foreign_key => :org_id
end
