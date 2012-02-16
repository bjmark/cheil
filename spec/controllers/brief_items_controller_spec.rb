#coding=utf-8
require 'spec_helper'

describe BriefItemsController do
  let(:rpm) { RpmOrg.create(:name=>'rpm') }
  #和rpm_org对应的cheil_org
  let(:cheil) { rpm.create_cheil_org(:name=>'cheil')}

  let(:rpm_user) { rpm.users.create(:name=>'rpm_user',:password=>'123')}
  let(:cheil_user) { cheil.users.create(:name=>'cheil_user',:password=>'123')}
  
  let(:vendor) { VendorOrg.create(:name=>'vendor')}

  let(:brief1){ rpm.briefs.create(:name=>'brief1')}

  def set_current_user(user)
    session[:user_id] = user.id
  end

  describe 'edit' do
    context 'user has no update right for this brief item' do
      it "should raise exception" do
        set_current_user(rpm_user)
        design1 = brief1.items.create(:name=>'design1')
        expect {
          get :edit,:id => design1.id
        }.to raise_exception(SecurityError)
      end
    end

    context 'user has update right for this brief item' do
      it "should be ok" do
        set_current_user(rpm_user)

        design1 = brief1.items.new(:name=>'design1')
        design1.op_right.add('self',rpm.id,'update')
        design1.save

        get :edit,:id => design1.id
        assigns(:brief).id.should == brief1.id
      end
    end
  end

  describe 'update' do
    let(:prod) do
      prod = brief1.items.new(:name=>'product1',:kind=>'product')
      prod.op_right.add('self',[rpm.id,cheil.id,vendor.id],'read')
      prod.op_right.add('self',rpm.id,'update')
      prod.save
      prod
    end

    let(:attr) do 
      {:name=>'product1',:quantity=>'10',:note=>'abc',:kind=>'design'}
    end

    it "should save attr:name,quantity,note,kind" do
      set_current_user(rpm_user)

      put :update,:id=>prod.id,:brief_item=>attr
      
      item = assigns[:item].reload
      item.name.should == 'product1'
      item.quantity.should == '10'
      item.note.should == 'abc'
      item.kind.should == 'design'
    end

    it "should notify cheil and vendor,but not rpm" do
      set_current_user(rpm_user)

      put :update,:id=>prod.id,:brief_item=>attr

      assigns[:item].op_notice.include?(cheil.id).should be_true
      assigns[:item].op_notice.include?(vendor.id).should be_true
      assigns[:item].op_notice.include?(rpm.id).should_not be_true

      assigns[:brief].op_notice.include?(cheil.id).should be_true
      assigns[:brief].op_notice.include?(vendor.id).should be_true
      assigns[:brief].op_notice.include?(rpm.id).should_not be_true
    end
  end

  describe "destroy" do
    let(:prod) do
      prod = brief1.items.new(:name=>'product1',:kind=>'product')
      prod.op_right.add('self',[rpm.id,cheil.id,vendor.id],'read')
      prod.op_right.add('self',rpm.id,'delete')
      prod.save
      prod
    end

    it "should notify cheil vendor,but not rpm" do
      set_current_user(rpm_user)
      brief = prod.brief
      prod_id = prod.id

      delete :destroy,:id=>prod.id

      brief.reload
      brief.op_notice.include?(cheil.id).should be_true
      brief.op_notice.include?(vendor.id).should be_true
      brief.op_notice.include?(rpm.id).should_not be_true
    end

    it "should delete the item" do
      set_current_user(rpm_user)
      brief = prod.brief
      prod_id = prod.id

      delete :destroy,:id=>prod.id
      
      BriefItem.where(:id=>prod_id).should be_blank
    end
  end
end
