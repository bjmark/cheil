class Brief < ActiveRecord::Base
  belongs_to :rpm_org,:foreign_key => :rpm_id
  belongs_to :cheil_org,:foreign_key => :cheil_id
  belongs_to :user
  has_many :items,:class_name=>'BriefItem',:foreign_key=>'fk_id'
  has_many :comments,
    :class_name=>'BriefComment',:foreign_key=>'fk_id',:order=>'id desc'

  has_many :solutions
  has_many :vendor_solutions
  has_one :cheil_solution

  has_many :attaches,:class_name=>'BriefAttach',:foreign_key => 'fk_id'

  validates :name, :presence => true

  def designs
    items.find_all_by_kind('design')
  end

  def products
    items.find_all_by_kind('product')
  end

  def send_to_cheil?
    self.cheil_id > 0
  end

  def send_to_cheil!
    self.cheil_org = rpm_org.cheil_org
    save
    self.create_cheil_solution(:org_id=>self.cheil_id)
  end

  def check_comment_right(a_user)
    return true if can_commented_by?(a_user)
    raise SecurityError
  end

  def can_commented_by?(a_user)
    owned_by?(a_user) or received_by?(a_user)
  end

  def check_read_right(a_user)
    return true if can_read_by?(a_user)
    raise SecurityError
  end

  def check_edit_right(a_user)
    return true if can_edit_by?(a_user)
    raise SecurityError
  end

  alias check_destroy_right check_edit_right

  def can_read_by?(a_user)
    return true if can_edit_by? a_user
    return true if received_by? a_user.org
    return true if consult_by? a_user.org
  end

  def can_edit_by?(a_user)
    owned_by?(a_user.org)
  end

  #ug is a user or a org
  def owned_by?(ug)
    if (u=ug).instance_of? User
      return true if u.id == user_id
    end

    if (g=ug).instance_of? RpmOrg
      return true if g.id == rpm_id
    end
  end
  
  #ug should be a cheil_org or a user
  def received_by?(ug)
    g = ug.instance_of?(User) ? ug.org : ug 
    g.instance_of?(CheilOrg) and (cheil_id == g.id)
  end

  #ug should be a vendor_org or a user
  def consult_by?(g)
    g.instance_of?(VendorOrg) and solutions.find_by_org_id(g.id)
  end

end
