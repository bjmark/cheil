#encoding=utf-8
#require 'cheil'
=begin
self:read,delete,lock
attach:read,update
item:read,update
comment:read,update
vendor_solution:read,update
cheil_solution:read

rpm
self:read,delete
attach:read,update
item:read,update
coment:read,update
cheil_solution:read

cheil
self:read,delete,lock
attach:read,update
item:read,update
coment:read,update
vendor_solution:read,update
cheil:solution:read

vendor
self:read
attach:read
item:read
=end

class Brief < ActiveRecord::Base
  STATUS = {
    10 => '方案中',
    20 => '待审定',
    30 => '执行中',
    40 => '物流',
    50 => '结算',
    60 => '完成'
  }

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
  scope :status, lambda {|d| d == 'all' ? where('') : where('status = ?',d)}

  def designs(reload=false)
    @designs = nil if reload
    @designs or (@designs = items.find_all_by_kind('design'))
  end

  def products(reload=false)
    @products = nil if reload
    @products or (@products = items.find_all_by_kind('product'))
  end

  def send_to_cheil?
    self.cheil_id > 0
  end

  def op
    @op ||= Cheil::Op.new(self) 
  end

  def op_right
    @op_right ||= Cheil::OpRight.new(self) 
  end

  def op_notice
    @op_notice ||= Cheil::OpNotice.new(self) 
  end

  def cancel?
    self.cancel == 'y'
  end

  def cur_status
    return '取消' if cancel?
    return '未发送' unless send_to_cheil?
    STATUS[self.status]
  end

end

