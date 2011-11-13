#encoding=utf-8
class RpmOrg < Org
  OP = {
    :brief=>[:index,:new,:create,:edit,:update,:destroy]
  }

  validates :name , :uniqueness => true
  validates :name , :presence => true
  has_one :cheil_org , :dependent => :destroy 
  has_many :briefs , :foreign_key => :rpm_id , :order => 'id DESC'

  def check_right(model,action)
    begin
      break unless OP[model]
      break unless OP[model].include?(action)
      return true
    end while false
    raise SecurityError
  end

  def self.nav_partial
    'share/rpm_menu'
  end

  def self.type_name
    'RPM'
  end

  def nav_links
    [
      ['新建 brief', '/briefs/new'],
      ['项目列表', '/briefs']
    ]
  end
end
