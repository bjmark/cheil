require 'spec_helper'

describe SessionsController do
=begin
  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
    end
  end
=end
  describe "GET 'create'" do
    describe "login fail" do
      it "should redirect to login page" do
        get 'create',:name=>'user',:password=>'123'
        response.should redirect_to(new_session_path)
      end
    end
    describe 'login success' do
      specify{
        rpm_user = User.create(:name=>'rpm_user',:password=>'123')
        rpm_org = RpmOrg.create(:name=>'rpm')
        rpm_org.users << rpm_user
        
        get 'create',:name=>rpm_user.name,:password=>'123'

        session[:user_id].should == rpm_user.id
        response.should redirect_to('/briefs')
      }
    end
  end

  describe "GET 'destroy'" do
    specify{
      get 'destroy'
      session[:user_id].should be_nil
      response.should redirect_to(new_session_path)
    }
  end
end
