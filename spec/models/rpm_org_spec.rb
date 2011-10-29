#encoding = utf-8
require 'spec_helper'

describe RpmOrg do
  #pending "add some examples to (or delete) #{__FILE__}"

  describe '重名' do 
    it "should create a error on :name" do
      RpmOrg.create(:name=>'rpm_dep')
      rpm_org = RpmOrg.new(:name=>'rpm_dep')
      rpm_org.save.should be_false
      rpm_org.should have(1).error_on(:name)
    end
  end

  describe '一个rpm和一个cheil重名' do
    it "不应有错误" do 
      CheilOrg.create(:name=>'mark')
      rpm_org = RpmOrg.new(:name=>'mark')
      rpm_org.save.should be_true
      rpm_org.errors.should be_empty
    end
  end

  describe '单表继承的行为' do
    before do
      cheil_org = CheilOrg.create(:name=>'mark')
      rpm_org = RpmOrg.create(:name=>'mark2')
    end
   
    it 'should have 2 org' do
      Org.all.size.should == 2
    end

    it 'shuld have 1 rpm' do
      RpmOrg.all.size.should == 1
    end

    it 'should have 1 cheil' do 
      CheilOrg.all.size.should == 1
    end

    it 'should be a instant of RpmOrg' do
      Org.find_by_name('mark2').should be_a_kind_of(Org)
      Org.find_by_name('mark2').should be_a_kind_of(RpmOrg)
    end
  end

  describe 'has many users' do
    let(:rpm) { RpmOrg.create(:name=>'mark2') }

    it 'should has 0 user' do
      rpm.should have(0).users
    end

    it 'should be RpmOrg' do
      rpm.users << User.new(:name => 'u1')
      u1 = rpm.users.find_by_name('u1')
      u1.rpm_org.should be_a_kind_of(RpmOrg)
    end
  end

  describe 'has_one cheil_org' do
    it 'should create a cheil_org' do
      rpm = RpmOrg.create(:name=>'rpm')
      cheil = CheilOrg.new(:name=>'cheil')
      cheil.new_record?.should be_true
      
      rpm.cheil_org = cheil
      cheil.new_record?.should be_false

      rpm.cheil_org.name.should == 'cheil'
      cheil.rpm_org.name.should == 'rpm'
    end

    it 'should destroy associate cheil too' do 
      rpm = RpmOrg.create(:name=>'rpm')
      #return a RpmOrg or CheilOrg ?
      cheil = rpm.create_cheil_org(:name=>'cheil')

      #guess it should be a CheilOrg
      cheil.should be_a_kind_of(CheilOrg)
      cheil.new_record?.should be_false

      rpm.destroy
      expect { 
        #cheil also destroy
        CheilOrg.find(cheil.id)
      }.to raise_error(ActiveRecord::RecordNotFound) 
    end

    it 'should be a kind of RpmOrg' do
      rpm = RpmOrg.create(:name=>'rpm')
      org = Org.find(rpm.id)
      org.should be_a_kind_of(RpmOrg)
      org.class.should == RpmOrg
=begin
      back_path = case org
                 when RpmOrg then rpm_orgs_path
                 when CheilOrg then cheil_orgs_path
                 when VendorOrg then vendor_orgs_path
                 end
     back_path.should == rpm_orgs_path
=end
    end
  end
end
