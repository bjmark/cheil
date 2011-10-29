class RpmOrg < Org
  validates :name , :uniqueness => true
  validates :name , :presence => true
  has_one :cheil_org , :dependent => :destroy 
  has_many :users , :foreign_key => :org_id
  has_many :briefs
end
