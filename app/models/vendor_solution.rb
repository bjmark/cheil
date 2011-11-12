class VendorSolution < Solution
  belongs_to :brief
  belongs_to :vendor_org,:foreign_key=>'org_id'
end
