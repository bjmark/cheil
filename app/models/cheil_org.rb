class CheilOrg < Org
  validates :name, :uniqueness => true
  validates :name , :presence => true
  belongs_to :rpm_org
  has_many :users , :foreign_key => :org_id
  has_many :brief_vendors , :foreign_key => :org_id
  has_many :briefs , :foreign_key => :cheil_id , :order => 'id DESC'
end
