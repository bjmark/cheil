require 'spec_helper'

describe SolutionsController do
  let(:rpm_org) { RpmOrg.create(:name=>'rpm') }
  let(:cheil_org) { rpm_org.create_cheil_org(:name=>'cheil')}
  let(:vendor_org) {VendorOrg.create(:name=>'vendor')}

  let(:rpm_user) { rpm_org.users.create(:name=>'rpm_user',:password=>'123')}
  let(:cheil_user) { cheil_org.users.create(:name=>'cheil_user',:password=>'123')}
  let(:vendor_user) { vendor_org.users.create(:name=>'vendor_user',:password=>'123')}


  let(:rpm_org2) { RpmOrg.create(:name=>'rpm2') }
  let(:cheil_org2) {CheilOrg.create(:name=>'cheil2')}
  let(:vendor_org2) {VendorOrg.create(:name=>'vendor2')}


  let(:rpm2_user) { rpm_org2.users.create(:name=>'rpm2_user',:password=>'123')}
  let(:cheil2_user) { cheil_org2.users.create(:name=>'cheil2_user',:password=>'123')}
  let(:vendor2_user) { vendor_org2.users.create(:name=>'vendor2_user',:password=>'123')}

  let(:brief) { cheil_org.rpm_org.briefs.create(:name=>'brief') }

  def set_current_user(user)
    session[:user_id] = user.id
  end

  describe 'index' do
    context 'current user is a rpm_user' do
      specify{
        set_current_user(rpm_user)
        expect{
          get :index,:brief_id=>brief.id
        }.to raise_exception(SecurityError)
      }
    end

    context 'current user is a vendor_user' do
      specify{
        set_current_user(vendor_user)
        expect{
          get :index,:brief_id=>brief.id
        }.to raise_exception(SecurityError)
      }
    end

    context 'current user is a bad cheil_user' do
      specify{
        set_current_user(cheil2_user)
        brief.send_to_cheil!
        expect{
          get :index,:brief_id=>brief.id
        }.to raise_exception(SecurityError)
      }
    end

    context 'current user is a good cheil_user' do
      specify{
        set_current_user(cheil_user)
        brief.send_to_cheil!
        get :index,:brief_id=>brief.id
        response.should render_template('index')
      }
    end
  end


  describe "show" do
    context 'a cheil_solution' do
      before do
        brief.send_to_cheil!
      end

      context 'a good rpm_user' do
        specify{
          set_current_user(rpm_user)
          get :show,:id=>brief.cheil_solution.id
          response.should render_template 'solutions/rpm/show'
        }
      end

      context 'a bad rpm_user' do
        specify{
          set_current_user(rpm2_user)
          expect{
            get :show,:id=>brief.cheil_solution.id
          }.to raise_exception(SecurityError)
        }
      end

      context 'a good cheil_user' do
        specify{
          set_current_user(cheil_user)
          get :show,:id=>brief.cheil_solution.id
          response.should render_template 'solutions/cheil/cheil_solution/show'
        }
      end
    end
  end
end
