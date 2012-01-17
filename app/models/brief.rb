#encoding=utf-8
#require 'cheil'

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

  validates_presence_of :name, :message=>'不可为空'

  scope :search_name, lambda {|word| word.blank? ? where('') : where('name like ?',"%#{word}%")}
  scope :deadline_great_than, lambda {|d| d.nil? ? where('') : where('deadline > ?',d)}
  scope :deadline_less_than, lambda {|d| d.nil? ? where('') : where('deadline < ?',d)}
  scope :create_date_great_than, lambda {|d| d.nil? ? where('') : where('created_at > ?',d)}
  scope :create_date_less_than, lambda {|d| d.nil? ? where('') : where('created_at < ?',d)}
  scope :update_date_great_than, lambda {|d| d.nil? ? where('') : where('updated_at > ?',d)}
  scope :update_date_less_than, lambda {|d| d.nil? ? where('') : where('updated_at < ?',d)}

  def designs(reload=false)
    @designs = nil if reload
    @designs or (@designs = items.find_all_by_kind('design'))
  end

  def designs=(d)
    @designs = d
  end

  def products(reload=false)
    @products = nil if reload
    @products or (@products = items.find_all_by_kind('product'))
  end

  def products=(p)
    @products = p
  end

  def send_to_cheil?
    self.cheil_id > 0
  end

  def send_to_cheil!
    self.cheil_org = rpm_org.cheil_org
    save
    self.create_cheil_solution(:org_id=>self.cheil_id)
  end

  def check_comment_right(org_id)
    can_commented_by?(org_id) or raise SecurityError
  end

  def can_commented_by?(org_id)
    owned_by?(org_id) or received_by?(org_id)
  end

  def check_read_right(org_id)
    can_read_by?(org_id) or raise SecurityError
  end

  def check_edit_right(org_id)
    can_edit_by?(org_id) or raise SecurityError
  end

  alias check_destroy_right check_edit_right

  def check_create_solution_right(org_id)
    received_by?(org_id) or raise SecurityError
  end

  def can_read_by?(org_id)
    can_edit_by?(org_id) or received_by?(org_id) or consult_by?(org_id)
  end

  def can_edit_by?(org_id)
    owned_by?(org_id) or received_by?(org_id)
  end

  def owned_by?(org_id)
    org_id == rpm_id
  end

  def received_by?(org_id)
    cheil_id == org_id
  end

  def consult_by?(org_id)
    solutions.find_by_org_id(org_id)
  end

  def op
    @op ||= Cheil::Op.new(self) 
  end
end

