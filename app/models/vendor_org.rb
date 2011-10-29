class VendorOrg < Org 
  has_many :users , :foreign_key => :org_id
  has_many :briefs
end
