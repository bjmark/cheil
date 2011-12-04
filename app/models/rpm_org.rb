#encoding=utf-8
class RpmOrg < Org
  OP = {
    :brief=>[:index,:new,:create,:edit,:update,:destroy]
  }

  validates_uniqueness_of :name , :message => '已存在'
  has_one :cheil_org , :dependent => :destroy 
  has_many :briefs , :foreign_key => :rpm_id , :order => 'id DESC'

  def self.name2
    'RPM'
  end

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
      ['新建需求', '/briefs/new'],
      ['需求列表', '/briefs']
    ]
  end
end
