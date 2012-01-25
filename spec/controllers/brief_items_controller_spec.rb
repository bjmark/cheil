#coding=utf-8
require 'spec_helper'

describe BriefItemsController do
  let(:rpm_org) { RpmOrg.create(:name=>'rpm') }
  #和rpm_org对应的cheil_org
  let(:cheil_org) { rpm_org.create_cheil_org(:name=>'cheil')}

  let!(:rpm_user) { rpm_org.users.create(:name=>'rpm_user',:password=>'123')}
  let!(:cheil_user) { cheil_org.users.create(:name=>'cheil_user',:password=>'123')}

  let!(:brief){ rpm_user.org.briefs.create(:name=>'brief')}

  def set_current_user(user)
    session[:user_id] = user.id
  end

  describe 'not login' do
    specify{
      get 'new'
      response.should redirect_to(new_session_path)
    }
  end

  describe 'new' do
    specify {
      set_current_user(rpm_user)
      
      get :new , :brief_id => brief.id
      assigns(:item).should be_a_new(BriefItem)
      assigns(:item).kind.should == 'design'
    }
  end

  describe 'edit' do
    specify {
      set_current_user(rpm_user)
      brief_item = brief.items.create(:name=>'d1')

      get :edit,:id => brief_item.id
      assigns(:item).should == brief_item
      assigns(:brief).should == brief
    }

    specify {
      set_current_user(cheil_user)
      brief_item = brief.items.create(:name=>'d1')

      expect {
        get :edit,:id => brief_item.id
      }.to raise_exception(SecurityError)
    }

    specify {
      set_current_user(cheil_user)
      brief_item = brief.items.create(:name=>'d1')
      brief.send_to_cheil!

      get :edit,:id => brief_item.id
      assigns(:item).should == brief_item
      assigns(:brief).should == brief
    }

  end

  describe 'create' do
    specify {
      set_current_user(rpm_user)
      brief_item = {
        :name => 'b1',
        :quantity => '10',
        :note => 'abc',
        :kind => 'design'
      }

      post :create,:brief_id=>brief.id,:brief_item=>brief_item
      assigns(:item).new_record?.should be_false
      assigns(:item).name.should == 'b1'
      assigns(:item).quantity.should == '10'
      assigns(:item).note.should == 'abc'
      assigns(:item).kind.should == 'design'
      assigns(:item).read_by.should == rpm_user.id.to_s
      assigns(:item).brief.read_by.should == rpm_user.id.to_s
      response.should redirect_to(brief_path(brief))
    }

    #name should not be blank
    specify {
      set_current_user(rpm_user)
      brief_item = {
        :name => '',
        :quantity => '10',
        :note => 'abc',
        :kind => 'design'
      }

      post :create,:brief_id=>brief.id,:brief_item=>brief_item
      assigns(:item).new_record?.should be_true
      assigns(:item).should have(1).errors_on(:name)
    }

  end

  describe 'update' do
    specify{
      set_current_user(rpm_user)
      item = brief.items.create(:name=>'d1')

      item_attr = {
        :name => 'b1',
        :quantity => '10',
        :note => 'abc',
        :kind => 'design'
      }

      put :update,:id=>item.id,:brief_item=>item_attr

      assigns(:item).name.should == 'b1'
      assigns(:item).quantity.should == '10'
      assigns(:item).note.should == 'abc'
      assigns(:item).kind.should == 'design'
      assigns(:item).read_by.should == rpm_user.id.to_s
      assigns(:item).brief.read_by.should == rpm_user.id.to_s
      response.should redirect_to(brief_path(brief))
    }
  end
end
