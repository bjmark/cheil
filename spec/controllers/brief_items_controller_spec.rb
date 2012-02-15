#coding=utf-8
require 'spec_helper'

describe BriefItemsController do
  let(:rpm_tv) { RpmOrg.create(:name=>'rpm_tv') }
  #和rpm_org对应的cheil_org
  let(:cheil_tv) { rpm_tv.create_cheil_org(:name=>'cheil_tv')}

  let(:rpm_tv_u1) { rpm_tv.users.create(:name=>'rpm_tv_u1',:password=>'123')}
  let(:cheil_tv_u1) { cheil_tv.users.create(:name=>'cheil_tv',:password=>'123')}

  let(:brief1){ rpm_tv.briefs.create(:name=>'brief1')}

  def set_current_user(user)
    session[:user_id] = user.id
  end

  describe 'edit' do
    context 'no update right' do
      specify {
        set_current_user(rpm_tv_u1)
        design1 = brief1.items.create(:name=>'design1')
        expect {
          get :edit,:id => design1.id
        }.to raise_exception(SecurityError)
      }
    end

    context 'has update rigt' do
      specify {
        set_current_user(rpm_tv_u1)

        design1 = brief1.items.new(:name=>'design1')
        design1.op_right.add('self',rpm_tv.id,'update')
        design1.save

        get :edit,:id => design1.id
        assigns(:brief).id.should == brief1.id
      }
    end
  end

  describe 'update' do

  end
end
