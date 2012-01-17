#encoding=utf-8
require 'spec_helper'

describe Brief do
  #pending "add some examples to (or delete) #{__FILE__}"
  let(:brief) { Brief.create(:name=>'brief') }
  let(:rpm_org) { RpmOrg.create(:name=>'rpm')}
  let(:cheil_org) { CheilOrg.create(:name=>'cheil')}
  let(:vendor_org) { VendorOrg.create(:name=>'vendor')}
  let(:user) { User.create(:name=>'user',:password=>'123') }
  let(:brief_item) { BriefItem.create }
  let(:brief_comment1) { BriefComment.create(:content=>'abc') }
  let(:brief_comment2) { BriefComment.create(:content=>'efg') }
  let(:cheil_solution) { CheilSolution.create }
  let(:vendor_solution) { VendorSolution.create }
  let(:brief_attach) { BriefAttach.create }

  
  # "validates_presence_of :name, :message=>'不可为空'"  
  describe "brief name is blank" do 
    it 'save should fail' do
      brief = Brief.new
      brief.name = ''
      brief.save
      brief.should have(1).errors_on(:name)
    end
  end

  describe "brief name is 'abc'" do
    it 'save should return true' do
      brief = Brief.new
      brief.name = 'abc'
      brief.save.should be_true
    end
  end

  # 'belongs_to :rpm_org,:foreign_key => :rpm_id' do 
  describe 'brief.rpm_id = rpm_org.id' do 
    specify{
      brief.rpm_id = rpm_org.id
      brief.rpm_org.should == rpm_org
    }
  end

  # 'belongs_to :cheil_org,:foreign_key => :cheil_id'  
  describe 'brief.cheil_id = cheil_org.id' do 
    specify{
      brief.cheil_id = cheil_org.id
      brief.cheil_org.should == cheil_org 
    }
  end

  # 'belongs_to :user' 
  describe 'brief.user_id = user.id' do
    specify{
      brief.user_id = user.id
      brief.user.should == user
    }
  end

  # "has_many :items,:class_name=>'BriefItem',:foreign_key=>'fk_id'" 
  describe "brief.items << Item.new" do
    it 'should raise a execption' do
      expect {
        brief.items << Item.new
      }.to raise_exception(ActiveRecord::AssociationTypeMismatch)
    end
  end

  describe "brief.items << brief_item " do
    specify{
      brief.items.empty?.should be_true
      brief.items << brief_item
      brief.items.empty?.should be_false 
      brief_item.fk_id.should == brief.id
    }
  end

  # 'has_many :solutions'  
  describe 'brief.solution << cheil_solution' do
    specify{
      brief.solutions << cheil_solution
      brief.solutions.length.should == 1
    }
  end

  describe 'brief.solution << vendor_solution' do
    specify{
      brief.solutions << vendor_solution
      brief.solutions.length.should == 1
    }
  end

  #has_many :vendor_solutions
  describe "brief.vendor_solutions << vendor_solution" do
    specify{
      brief.vendor_solutions << vendor_solution
      brief.vendor_solutions.length.should == 1
      brief.solutions.length.should == 1
      brief.cheil_solution.should be_nil
    }
  end

  #has_one :cheil_solution
  describe "brief.create_cheil_solution" do
    specify{
      c = brief.create_cheil_solution
      brief.cheil_solution.should == c 
    } 
  end

  # "has_many :comments,:class_name=>'BriefComment',:foreign_key=>'fk_id',:order=>'id desc'"  
  describe "brief.comments order desc" do 
    specify{
      brief.comments << brief_comment1
      brief.comments << brief_comment2
      brief.comments.first.should eql(brief_comment2)
    }
  end

  # "has_many :attaches,:class_name=>'BriefAttach',:foreign_key => 'fk_id'" 
  describe "should have one brief_attach" do
    specify{
      brief.attaches << brief_attach
      Attach.create(:fk_id=>brief.id)
      brief.attaches.length.should == 1
    }
  end

  describe '#designs' do
    it 'should have one design' do
      brief.items.create(:name=>'d1',:kind=>'design')
      brief.designs.length.should == 1
    end

    it 'should return 0 design' do
      brief.designs.length.should == 0
    end
  end

  describe '#product' do
    it 'should return 0 product' do
      brief.products.length.should == 0
    end

    it 'should have one product' do
      brief.items << BriefItem.new(:name=>'p1',:kind=>'product')
      brief.products.length.should == 1
    end
  end

  describe '#send_to_cheil?' do
    specify {
      brief.cheil_id.should == 0
    }

    specify {
      brief.send_to_cheil?.should be false
    }
  end

  describe '#send_to_cheil!' do
    it 'send to cheil' do
      rpm_org.cheil_org = cheil_org
      brief.rpm_org = rpm_org
      brief.send_to_cheil!
      brief.cheil_id.should == cheil_org.id
      brief.cheil_solution.org_id.should == cheil_org.id
    end
  end

  def send_brief
    rpm_org.cheil_org = cheil_org
    brief.rpm_org = rpm_org
    brief.send_to_cheil!
  end

  describe '#owned_by?' do
    before {
      send_brief
    }

    specify {
      brief.owned_by?(rpm_org.id).should be_true
    }

    specify {
      brief.owned_by?(cheil_org.id).should be_false
    }
  end

  describe '#received_by?' do
    before {
      send_brief
    }

    specify {
      brief.received_by?(cheil_org.id).should be_true
    }
  end

  describe 'check_comment_right(org_id) and can_commented_by?(org_id)' do
    specify{
      send_brief
      brief.can_commented_by?(rpm_org.id).should be_true
      brief.can_commented_by?(cheil_org.id).should be_true
      brief.can_commented_by?(vendor_org.id).should be_false

      brief.check_comment_right(rpm_org.id).should be_true
      brief.check_comment_right(cheil_org.id).should be_true
      expect {
        brief.check_comment_right(vendor_org.id)
      }.to raise_exception(SecurityError)
    }
  end

  describe 'can_read_by?(org_id) and check_read_right(org_id)' do
    specify{
      send_brief
      brief.can_read_by?(rpm_org.id).should be_true
      brief.can_read_by?(cheil_org.id).should be_true
      brief.can_read_by?(vendor_org.id).should be_false

      brief.check_read_right(rpm_org.id).should be_true
      brief.check_read_right(cheil_org.id).should be_true
      expect {
        brief.check_read_right(vendor_org.id)
      }.to raise_exception(SecurityError)

      brief.vendor_solutions << VendorSolution.new(:org_id=>vendor_org.id)
      brief.can_read_by?(vendor_org.id).should be_true
      brief.check_read_right(vendor_org.id).should be_true
    }

  end

  describe '#consult_by?(g)' do
    specify {
      brief.vendor_solutions << VendorSolution.new(:org_id=>vendor_org.id)
      brief.consult_by?(vendor_org.id).should be_true
    }
  end

=begin
  scope :search_name, lambda {|word| word.blank? ? where('') : where('name like ?',"%#{word}%")}
  scope :deadline_great_than, lambda {|d| d.nil? ? where('') : where('deadline > ?',d)}
  scope :deadline_less_than, lambda {|d| d.nil? ? where('') : where('deadline < ?',d)}
  scope :create_date_great_than, lambda {|d| d.nil? ? where('') : where('created_at > ?',d)}
  scope :create_date_less_than, lambda {|d| d.nil? ? where('') : where('created_at < ?',d)}
  scope :update_date_great_than, lambda {|d| d.nil? ? where('') : where('updated_at > ?',d)}
  scope :update_date_less_than, lambda {|d| d.nil? ? where('') : where('updated_at < ?',d)}
=end

  describe 'scope' do
    specify {
      brief1 = Brief.create(:name=>'brief_西门',:deadline=>5.day.from_now)
      brief2 = Brief.create(:name=>'brief_装修',:deadline=>10.day.from_now)
      Brief.search_name('rie').length.should == 2
      Brief.search_name('西').length.should == 1
      Brief.search_name('abc').length.should == 0
      Brief.search_name('').length.should == 2

      Brief.deadline_great_than(6.day.from_now).length.should == 1
      Brief.deadline_great_than(3.day.from_now).length.should  == 2
      Brief.deadline_great_than(nil).length.should == 2

      Brief.deadline_less_than(6.day.from_now).length.should == 1
      Brief.deadline_less_than(3.day.from_now).length.should  == 0
      Brief.deadline_less_than(nil).length.should == 2
    }
  end

  describe 'op' do
    specify {
      b = Brief.new(:name=>'abc')
      b.op.save_by(1).should be_true
      b.read_by.should == '1'
      b.op.read_by_to_a.should == %w(1)
      b.op.read?(1).should be_true
      
      b.op.read_by(2)
      
      b2 = Brief.find(b.id)
      b2.op.read?(2).should be_true
    }
  end
end
