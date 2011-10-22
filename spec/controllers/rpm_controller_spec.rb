# encoding: utf-8
require 'spec_helper'

describe RpmController do

  describe "not login" do
    it "should redirect to login page" do
      get 'briefs'
      response.should redirect_to(users_login_path)
    end
  end

  describe "login" do
    before do
      rpm = Org.create :name=>'rpm_dep1',:role=>'rpm'
      u = rpm.users.create :name=>'rpm_u1',:password=>'123'
      session[:user] = "rpm_#{u.id}"
    end

    it "briefs should not be nil" do
      get 'briefs'
      assigns(:briefs).should_not be_nil 
      response.should_not redirect_to(users_login_path)
    end
  end

  describe '#show_brief' do
    before do
      rpm = Org.create :name=>'rpm_dep1',:role=>'rpm'
      u = rpm.users.create :name=>'rpm_u1',:password=>'123'
      session[:user] = "rpm_#{u.id}"
    end

    it 'should raise error when brief does not belong to cur_user.org' do
      u = User.find_by_name('rpm_u1')
      attrs = {
        :name => 'brief2',
        :user_id => u.id + 1,
        :org_id => u.org_id + 1
      }
      b=Brief.create(attrs)
      expect {
        get 'show_brief',:id=>b.id
      }.to raise_error(SecurityError)
    end
  end

  describe '#delete_brief' do
    before do
      rpm = Org.create :name=>'rpm_dep1',:role=>'rpm'
      u = rpm.users.create :name=>'rpm_u1',:password=>'123'
      session[:user] = "rpm_#{u.id}"
    end

    it 'should delete 所有关联项' do
      u = User.find_by_name('rpm_u1')
      
      #创建一个brief
      b=Brief.create({:name=>'brief1',:org_id=>u.org_id,:user_id=>u.id})
     
      #给brief创建一个design,一个proudct
      b.items << Item.new({:name=>'item1','kind'=>'design1'})
      b.items << Item.new({:name=>'item2','kind'=>'product1'})
      
      b.should have(2).items
      item_ids = b.item_ids.join(',')

      #创建2个vendor
      vendor1 = Org.create({:name=>'vendor1',:role=>'vendor'})
      vendor2 = Org.create({:name=>'vendor2',:role=>'vendor'})

      #把b指派给vendor1,vendor2
      b.brief_vendors << BriefVendor.new({:org_id=>vendor1.id})
      b.brief_vendors << BriefVendor.new({:org_id=>vendor2.id})

      b.should have(2).brief_vendors

      #创建指派给vendor1,vendor2的item
      bv = b.brief_vendors.find_by_org_id(vendor1.id)
      bv.items << Item.new
      bv.items << Item.new

      bv.should have(2).items

      bv_item_ids = bv.item_ids.join(',')

      post :delete_brief,:id=>b.id

      #删除b
      expect { Brief.find(b.id) }.to raise_error(ActiveRecord::RecordNotFound)
      #删除b的item
      Item.where("id in (#{item_ids})").all.size.should == 0

      #删除b的vendor
      BriefVendor.find_all_by_brief_id(b.id).size.should == 0

      Item.where("id in (#{bv_item_ids})").all.should be_empty
    end
  end
end
