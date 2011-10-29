require 'spec_helper'

describe RpmOrgsController do
  before do
    u = AdminUser.create(:name=>'admin',:password=>'123')
    session[:user] = "admin_#{u.id}"
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new rpm_org" do
        expect {
          post :create, :rpm_org => {:name=>'rpm'}
        }.to change(RpmOrg, :count).by(1)
      end

      it "assigns a newly created user as @rpm_org" do
        post :create, :rpm_org => {:name=>'rpm'}
        assigns(:rpm_org).should be_a(RpmOrg)
        assigns(:rpm_org).should be_persisted
      end

      it "redirects to the rpm_orgs_path" do
        post :create, :rpm_org => {:name=>'rpm'}
        response.should redirect_to(assigns(:rpm_org))
      end

      it "have one cheil_org with same name" do
        post :create, :rpm_org => {:name=>'rpm'}
        assigns(:rpm_org).cheil_org.name.should == 'rpm'
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved user as @user" do
        # Trigger the behavior that occurs when invalid params are submitted
        RpmOrg.any_instance.stub(:save).and_return(false)
        post :create, :rpm_org => {}
        assigns(:rpm_org).should be_a_new(RpmOrg)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        RpmOrg.any_instance.stub(:save).and_return(false)
        post :create, :rpm_org => {}
        response.should render_template("new")
      end

      it "duplicate name" do 
        RpmOrg.create(:name=>'dup')
        post :create, :rpm_org =>{:name=>'dup'}
        assigns(:rpm_org).should be_a_new(RpmOrg)
      end

      it "blank name" do 
        post :create, :rpm_org =>{:name=>' '}
        assigns(:rpm_org).should be_a_new(RpmOrg)
      end
    end
  end

  describe "PUT update" do
    let(:cheil_org){CheilOrg.new(:name=>'rpm')}
    let(:rpm_org){RpmOrg.create(:name=>'rpm')}
    before {rpm_org.cheil_org = cheil_org}

    describe "with valid params" do
      it "updates the requested user" do
        # Assuming there are no other users in the database, this
        # specifies that the User created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        RpmOrg.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => rpm_org.id, :rpm_org => {'these' => 'params'}
      end

      it "assigns the requested user as @rpm_org" do
        put :update, :id => rpm_org.id, :rpm_org => {:name=>'rpm'}
        assigns(:rpm_org).should eq(rpm_org)
      end
    end

    describe "with invalid params" do
      it "re-renders the 'edit' template" do
        RpmOrg.create! :name=>'rpm2'
        put :update, :id => rpm_org.id, :rpm_org => {:name=>'rpm2'}
        assigns(:rpm_org).should have(1).error_on(:name)
        response.should render_template("edit")
      end

      it "blank name" do
        put :update, :id => rpm_org.id, :rpm_org => {:name=>''}
        assigns(:rpm_org).should have(1).error_on(:name)
      end
    end
  end

  describe "DELETE destroy" do
    let(:cheil_org){CheilOrg.new(:name=>'rpm')}
    let(:rpm_org){RpmOrg.create(:name=>'rpm')}
    before {rpm_org.cheil_org = cheil_org}

    it "destroys the requested user" do
      expect {
        delete :destroy, :id => rpm_org.id
      }.to change(RpmOrg, :count).by(-1)

      expect {
        CheilOrg.find(cheil_org.id)
      }.to raise_exception(ActiveRecord::RecordNotFound)
    end

    it "redirects to the users list" do
      delete :destroy, :id => rpm_org.id
      response.should redirect_to(rpm_orgs_path)
    end
  end
end
