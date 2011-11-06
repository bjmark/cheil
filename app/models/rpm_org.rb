class RpmOrg < Org
  OP = {
    :brief=>[:index,:new,:create,:edit,:update,:destroy]
  }

  validates :name , :uniqueness => true
  validates :name , :presence => true
  has_one :cheil_org , :dependent => :destroy 
  has_many :users , :foreign_key => :org_id
  has_many :briefs , :foreign_key => :rpm_id , :order => 'id DESC'

  def check_right(model,action)
    begin
      break unless OP[model]
      break unless OP[model].include?(action)
      return true
    end while false
    raise SecurityError
  end
end
