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
  end

  describe 'create' do
  end
end
