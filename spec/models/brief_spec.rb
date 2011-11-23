require 'spec_helper'

describe Brief do
  #pending "add some examples to (or delete) #{__FILE__}"
  let(:brief) { Brief.create(:name=>'brief') }
  let(:rpm_org) { RpmOrg.create(:name=>'rpm')}
  let(:cheil_org) { CheilOrg.create(:name=>'cheil')}
  let(:vendor_org) { VendorOrg.create(:name=>'cheil')}
  let(:user) { User.create(:name=>'user') }
  let(:brief_item) { BriefItem.create }
  let(:brief_comment1) { BriefComment.create }
  let(:brief_comment2) { BriefComment.create }
  let(:cheil_solution) { CheilSolution.create }
  let(:vendor_solution) { VendorSolution.create }
  let(:brief_attach) { BriefAttach.create }

  describe 'belongs_to :rpm_org,:foreign_key => :rpm_id' do 
    it 'should set rpm_id' do
      brief.rpm_org = rpm_org
      brief.rpm_id.should == rpm_org.id
    end

    specify { brief.rpm_org.should be_nil}
  end

  describe 'belongs_to :cheil_org,:foreign_key => :cheil_id' do 
    specify { brief.cheil_org.should be_nil}

    it 'should set cheil_id' do
      brief.cheil_org = cheil_org
      brief.cheil_id.should == cheil_org.id
    end
  end

  describe 'belongs_to :user' do
    specify { brief.user.should be_nil}

    it 'should set user_id' do
      brief.user = user
      brief.user_id.should == user.id
    end

  end

  describe "has_many :items,:class_name=>'BriefItem',:foreign_key=>'fk_id'" do
    specify { brief.items.should be_empty}
    
    it 'should raise a execption' do
      expect {
        brief.items << Item.new
      }.to raise_exception(ActiveRecord::AssociationTypeMismatch)
    end

    it 'have one item' do
      brief.items << brief_item
      brief.items.length.should == 1 
      brief_item.fk_id.should == brief.id
    end
  end

  describe 'has_many :solutions' do 
    before do 
      brief.solutions << cheil_solution
      brief.solutions << vendor_solution
    end

    it 'should have two solutions' do
      brief.solutions.length.should == 2
    end

    it 'should have one vendor_solutions' do
      brief.vendor_solutions.length.should == 1
    end

    specify {
      brief.cheil_solution.should == cheil_solution
    }
  end

  describe "has_many :comments,:class_name=>'BriefComment',:foreign_key=>'fk_id',:order=>'id desc'" do 
    it 'brief.comments order desc' do
      brief.comments << brief_comment1
      brief.comments << brief_comment2
      brief.comments.first.should eql(brief_comment2)
    end
  end

  describe "has_many :attaches,:class_name=>'BriefAttach',:foreign_key => 'fk_id'" do
    it 'should have one brief_attach' do
      brief.attaches << brief_attach
      Attach.create(:fk_id=>brief.id)
      brief.attaches.length.should == 1
    end
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

  describe '#owned_by?' do
    before {
      rpm_org.cheil_org = cheil_org
      brief.rpm_org = rpm_org
      brief.send_to_cheil!
    }

   specify {
      brief.owned_by?(rpm_org.id).should be_true
    }

    it 'should owned by the user' do
      user.org = rpm_org
      brief.owned_by?(user.org_id).should be_true
    end

    specify {
      brief.owned_by?(cheil_org.id).should be_false
    }
  end
   
  describe '#received_by?' do
    before {
      rpm_org.cheil_org = cheil_org
      brief.rpm_org = rpm_org
      brief.send_to_cheil!
    }

    specify {
      brief.received_by?(cheil_org.id).should be_true
    }

    specify {
      user.org = cheil_org
      brief.received_by?(user.org_id).should be_true
    }
  end

  describe '#consult_by?(g)' do
    specify {
      brief.vendor_solutions << VendorSolution.new(:org_id=>vendor_org.id)
      brief.consult_by?(vendor_org.id).should be_true
    }
  end
=begin
    it 'should raise a exception' do
      expect {
        user.org = CheilOrg.create(:name=>'cheil2')
        brief.check_comment_right(user)
      }.to raise_exception(SecurityError)
    end
=end
 
end
