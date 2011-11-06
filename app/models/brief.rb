class Brief < ActiveRecord::Base
  belongs_to :rpm_org,:foreign_key => :rpm_id
  belongs_to :cheil_org,:foreign_key => :cheil_id
  belongs_to :user
  has_many :items,:class_name=>'BriefItem',:foreign_key=>'fk_id'
  has_many :comments,
    :class_name=>'BriefComment',:foreign_key=>'fk_id',:order=>'id desc'

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

  def check_comment_right(user)
    case user.org_id
    when rpm_id , cheil_id 
    else raise SecurityError
    end
  end

  def check_read_right(user)
    case user.org
    when RpmOrg then return if rpm_org == user.org
    when CheilOrg then return if cheil_org == user.org
    when VendorOrg then return if brief_vendors.find_by_org_id(user.org_id) 
    end

    raise SecurityError
  end

  def check_edit_right(user)
    case user.org
    when RpmOrg then return if rpm_org == user.org
    end

    raise SecurityError
  end

  def check_destroy_right(user)
    check_edit_right(user)
  end
end
