require 'spec_helper'

describe BriefsController do
  let(:rpm_org) { RpmOrg.create(:name=>'rpm') }
  let(:cheil_org) { rpm_org.create_cheil_org(:name=>'cheil')}
  let(:vendor_org) {VendorOrg.create(:name=>'vendor')}

  let(:rpm_org2) { RpmOrg.create(:name=>'rpm2') }
  let(:cheil_org2) {CheilOrg.create(:name=>'cheil2')}
  let(:vendor_org2) {VendorOrg.create(:name=>'vendor2')}

  let(:rpm_user) { rpm_org.users.create(:name=>'rpm_user',:password=>'123')}
  let(:cheil_user) { cheil_org.users.create(:name=>'cheil_user',:password=>'123')}
  let(:vendor_user) { vendor_org.users.create(:name=>'vendor_user',:password=>'123')}

  let(:rpm2_user) { rpm_org2.users.create(:name=>'rpm2_user',:password=>'123')}
  let(:cheil2_user) { cheil_org2.users.create(:name=>'cheil2_user',:password=>'123')}
  let(:vendor2_user) { vendor_org2.users.create(:name=>'vendor2_user',:password=>'123')}

  let(:valid_attributes){ {:name=>'brief'}}

  def set_current_user(user)
    session[:user_id] = user.id
  end

  describe "GET index" do
    describe "not login" do
      specify{
        get 'index'
        response.should redirect_to(new_session_path)
      }
    end

    describe "current user is a rpm_user" do
      specify{
        set_current_user(rpm_user)

        brief1 = rpm_org.briefs.create(:name=>'brief1')
        rpm_org2.briefs.create(:name=>'brief2')

        get 'index'
        assigns(:briefs).should eq([brief1])
      }
    end

    describe "current user is a cheil_user" do
      specify{
        set_current_user(cheil_user)

        brief1 = rpm_org.briefs.create(:name=>'brief1')

        get 'index'
        assigns(:briefs).should eq([])

        brief1.send_to_cheil!

        get 'index'
        assigns(:briefs).should eq([brief1])
      }
    end

    describe "current user is a vendor_user" do
      specify{
        set_current_user(vendor_user)

        brief1 = rpm_org.briefs.create(:name=>'brief1')
        get 'index'
        assigns(:briefs).should eq([])

        brief1.send_to_cheil!
        get 'index'
        assigns(:briefs).should eq([])

        brief1.vendor_solutions.create(:org_id=>vendor_user.org_id)
        get 'index'
        assigns(:briefs).should eq([brief1])
      }
    end

  end

  describe "GET show" do
    #a brief belongs to rpm_org
    let(:brief1){ rpm_org.briefs.create(:name=>'brief1') }

    context "authorized user" do
      it "is a rpm_user" do
        set_current_user(rpm_user)

        get 'show',:id=>brief1.id
        assigns(:brief).should eq(brief1)
        response.should render_template('briefs/rpm/show')
      end

      it "is a cheil_user" do
        set_current_user(cheil_user)
        brief1.send_to_cheil!

        get 'show',:id=>brief1.id
        assigns(:brief).should eq(brief1)
        response.should render_template('briefs/cheil/show')
      end

      it "is a vendor_user" do
        set_current_user(vendor_user)
        brief1.send_to_cheil!
        brief1.vendor_solutions.create(:org_id=>vendor_user.org_id)

        get 'show',:id=>brief1.id
        assigns(:brief).should eq(brief1)
        response.should render_template('briefs/vendor/show')
      end
    end

    context "unauthorized user" do
      it "is a rpm2_user" do
        set_current_user(rpm2_user)
        expect { 
          get 'show',:id=>brief1.id
        }.to raise_exception(SecurityError)
      end

      it "is a cheil user" do
        set_current_user(cheil_user)
        expect { 
          get 'show',:id=>brief1.id
        }.to raise_exception(SecurityError)
      end

      it "is a vendor user" do
        set_current_user(vendor_user)
        expect { 
          get 'show',:id=>brief1.id
        }.to raise_exception(SecurityError)
      end
    end
  end

  describe "GET new" do
    context "current user is a rpm_user" do
      specify{
        set_current_user(rpm_user)
        get 'new'
        response.should render_template('new')
      }
    end

    context "current user is a cheil_user" do
      specify{
        set_current_user(cheil_user)
        expect { 
          get 'new' 
        }.to raise_exception(SecurityError)
      }
    end

    context "current user is a vendor_user" do
      specify{
        set_current_user(vendor_user)
        expect { 
          get 'new' 
        }.to raise_exception(SecurityError)
      }
    end
  end

  describe "GET edit" do
    #a brief belongs to rpm_org
    let(:brief1){ rpm_org.briefs.create(:name=>'brief1') }

    context "current user is a rpm_user" do
      specify{
        set_current_user(rpm_user)
        get 'edit',:id=>brief1.id
        response.should render_template('edit')

        set_current_user(rpm2_user)
        expect {
          get 'edit',:id=>brief1.id
        }.to raise_exception(SecurityError)
      }
    end

    context "current user is a cheil_user" do
      specify{
        set_current_user(cheil_user)
        expect { 
          get 'edit',:id=>brief1.id
        }.to raise_exception(SecurityError)
      }

      specify{
        set_current_user(cheil_user)
        brief1.send_to_cheil!
        get 'edit',:id=>brief1.id
        response.should render_template('edit')
      }
    end

    context "current user is a vendor_user" do
      specify{
        set_current_user(vendor_user)
        expect { 
          get 'edit',:id=>brief1.id 
        }.to raise_exception(SecurityError)
      }
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Brief" do
        set_current_user(rpm_user)
        expect {
          post :create, :brief => valid_attributes
        }.to change(Brief, :count).by(1)
      end

      it "assigns a newly created brief as @brief" do
        set_current_user(rpm_user)
        post :create, :brief => valid_attributes
        assigns(:brief).should be_a(Brief)
        assigns(:brief).should be_persisted
        assigns(:brief).rpm_org.should eq(rpm_user.org)
        assigns(:brief).user.should eq(rpm_user)
      end

      it "redirects to the created brief" do
        set_current_user(rpm_user)
        post :create, :brief => valid_attributes
        response.should redirect_to(briefs_path)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved brief as @brief" do
        set_current_user(rpm_user)
        post :create, :brief => {}
        assigns(:brief).should be_a_new(Brief)
      end

      it "re-renders the 'new' template" do
        set_current_user(rpm_user)
        post :create, :brief => {}
        response.should render_template("new")
      end
    end

    context "current user is a cheil_user" do
      specify{
        set_current_user(cheil_user)
        expect { 
          post 'create',:brief=>valid_attributes 
        }.to raise_exception(SecurityError)
      }
    end

    context "current user is a vendor_user" do
      specify{
        set_current_user(vendor_user)
        expect { 
          post 'create',:brief=>valid_attributes 
        }.to raise_exception(SecurityError)
      }
    end

  end

  describe "PUT update" do
    let(:brief){ rpm_user.org.briefs.create(:name=>'brief') }

    describe "with valid params" do
      it "assigns the requested brief as @brief" do
        set_current_user(rpm_user)
        put :update, :id => brief.id, :brief => valid_attributes
        assigns(:brief).should eq(brief)
      end

      it "redirects to the brief" do
        set_current_user(rpm_user)
        put :update, :id => brief.id, :brief => valid_attributes
        response.should redirect_to(brief)
      end
    end

    describe "with invalid params" do
      it "assigns the brief as @brief" do
        set_current_user(rpm_user)
        put :update, :id => brief.id, :brief => {:name=>''}
        assigns(:brief).should eq(brief)
      end

      it "re-renders the 'edit' template" do
        set_current_user(rpm_user)
        put :update, :id => brief.id, :brief => {:name=>''}
        response.should render_template("edit")
      end
    end

    context "current user is a cheil_user" do
      specify{
        set_current_user(cheil_user)
        expect { 
          put 'update',:id => brief,:brief => valid_attributes 
        }.to raise_exception(SecurityError)
      }

      specify{
        set_current_user(cheil_user)
        brief.send_to_cheil!
        put 'update',:id => brief,:brief => valid_attributes 
        response.should redirect_to(brief)
      }
    end

    context "current user is a vendor_user" do
      specify{
        set_current_user(vendor_user)
        expect { 
          put 'update',:id => brief,:brief => valid_attributes 
        }.to raise_exception(SecurityError)
      }
    end

  end

  describe "DELETE destroy" do
    let(:brief) { rpm_user.org.briefs.create(:name=>'brief') }
    
    it "destroys the requested brief" do
      set_current_user(rpm_user)
      id = brief.id

      expect {
        delete :destroy, :id => id
      }.to change(Brief, :count).by(-1)
    end

    it "redirects to the briefs list" do
      set_current_user(rpm_user)
      delete :destroy, :id => brief.id
      response.should redirect_to(briefs_url)
    end

    context "rpm2_user don't have delete right" do
      specify {
        set_current_user(rpm2_user)
        expect {
          delete :destroy, :id => brief.id
        }.to raise_exception(SecurityError)
      }
    end

    context "current user is a cheil_user" do
      specify{
        set_current_user(cheil_user)
        expect { 
          delete 'destroy',:id => brief.id
        }.to raise_exception(SecurityError)
      }
    end

    context "current user is a vendor_user" do
      specify{
        set_current_user(vendor_user)
        expect { 
          delete 'destroy',:id => brief.id
        }.to raise_exception(SecurityError)
      }
    end
  end

  describe "send_to_cheil" do
    let(:brief) { rpm_user.org.briefs.create(:name=>'brief') }

    context "current user is good rpm_user" do
      specify{
        set_current_user(rpm_user)
        put 'send_to_cheil',:id => brief.id
        brief.reload.cheil_org.should == rpm_user.org.cheil_org 
      }
    end

    context "current user is bad rpm_user" do
      specify{
        set_current_user(rpm2_user)
        expect{
          put 'send_to_cheil',:id => brief.id
        }.to raise_exception(SecurityError)
      }
    end

    context "current user is a cheil_user" do
      specify{
        set_current_user(cheil_user)
        expect { 
          put 'send_to_cheil',:id => brief.id
        }.to raise_exception(SecurityError)
      }
    end

    context "current user is a vendor_user" do
      specify{
        set_current_user(vendor_user)
        expect { 
          put 'send_to_cheil',:id => brief.id
        }.to raise_exception(SecurityError)
      }
    end
  end
end
