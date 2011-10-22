require 'spec_helper'

def login 
  cheil = Org.create :name=>'cheil_dep1',:role=>'cheil'
  u = cheil.users.create :name=>'cheil_u1',:password=>'123'
  session[:user] = "cheil_#{u.id}"
end

describe CheilController do
  describe '#briefs' do
    describe "not login" do
      it "should redirect to login page" do
        get 'briefs'
        response.should redirect_to(users_login_path)
      end
    end

    describe "login" do
      before { login }
      it "briefs should not be nil" do
        get 'briefs'
        assigns(:briefs).should_not be_nil 
        response.should_not redirect_to(users_login_path)
      end
    end
  end

  describe '#show_brief' do
    before { login }

    it "shold set @brief,@vendor" do
      b=Brief.create :name=>'brief1'

      bv1 = BriefVendor.new
      bv2 = BriefVendor.new

      b.brief_vendors << [bv1,bv2]

      vendor1 = Org.create :name=>'vendor1',:role=>'vendor'
      vendor2 = Org.create :name=>'vendor2',:role=>'vendor'

      vendor1.brief_vendors << bv1
      vendor2.brief_vendors << bv2

      get :show_brief,:id=>b.id

      assigns(:brief).should be_a(Brief)
      assigns(:brief).id.should == b.id

      assigns(:vendors).length.should == 2
      assigns(:vendors)[0].should be_a(Org)
    end

    it "should raise a error when not find" do
      expect { 
        get :show_brief,:id=>0
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  #get post 'cheil/briefs/:brief_id/vendors/:vendor_id/items/:item_id'=>
  #:brief_vendor_add_item,:as=>'cheil_brief_vendor_add_item'
  
  #delete 'cheil/briefs/:brief_id/vendors/:vendor_id/items/:item_id'=>
  #:brief_vendor_del_item,:as=>'cheil_brief_vendor_del_item'
  describe '#brief_vendor_add_item and #brief_vendor_del_item' do
    before { login }

    it 'should add new item whos parent_is is set' do
      b = Brief.create :name=>'brief1'
      
      item = Item.new(:name=>'item1',:kind=>'design')
      b.items << item

      vendor1 = Org.create :name=>'vendor1',:role=>'vendor'

      b.brief_vendors << BriefVendor.new{|r| r.org_id = vendor1.id}

      post :brief_vendor_add_item,
        :brief_id=>b.id,:vendor_id=>vendor1.id,:item_id=>item.id
      
      bv = b.brief_vendors.find_by_org_id(vendor1.id)
      
      bv.should have(1).items
      bv.items.find_by_parent_id(item.id).should_not be_nil 

      delete :brief_vendor_del_item,
        :brief_id=>b.id,:vendor_id=>vendor1.id,:item_id=>item.id
      bv.should have(0).items

    end
  end
end

