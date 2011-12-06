#encoding=utf-8
class CheilOrg < Org
  validates_uniqueness_of :name, :message=>'已存在'

  belongs_to :rpm_org
  has_many :briefs , :foreign_key => :cheil_id , :order => 'id DESC'

  def self.nav_partial
    'share/cheil_menu'
  end

  def self.type_name
    'Cheil'
  end

  def nav_links
    [['需求列表', '/briefs']]
  end

end
