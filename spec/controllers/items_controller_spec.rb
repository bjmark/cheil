require 'spec_helper'

describe ItemsController do
  let!(:rpm_org) { RpmOrg.create(:name=>'rpm') }
  let!(:cheil_org) { rpm_org.create_cheil_org(:name=>'cheil')}
  let!(:vendor_org) {VendorOrg.create(:name=>'vendor')}

  let!(:rpm_org2) { RpmOrg.create(:name=>'rpm2') }
  let!(:cheil_org2) {CheilOrg.create(:name=>'cheil2')}
  let!(:vendor_org2) {VendorOrg.create(:name=>'vendor2')}

  let!(:rpm_user) { rpm_org.users.create(:name=>'rpm_user',:password=>'123')}
  let!(:cheil_user) { cheil_org.users.create(:name=>'cheil_user',:password=>'123')}
  let!(:vendor_user) { vendor_org.users.create(:name=>'vendor_user',:password=>'123')}

  let!(:rpm2_user) { rpm_org2.users.create(:name=>'rpm2_user',:password=>'123')}
  let!(:cheil2_user) { cheil_org2.users.create(:name=>'cheil2_user',:password=>'123')}
  let!(:vendor2_user) { vendor_org2.users.create(:name=>'vendor2_user',:password=>'123')}

  let!(:brief){ rpm_user.org.briefs.create(:name=>'brief')}

  def set_current_user(user)
    session[:user_id] = user.id
  end

  describe "GET new" do
    context 'not login' do
      specify{
        get 'new'
        response.should redirect_to(new_session_path)
      }
    end

    context 'lack of param' do
      specify{
        set_current_user(rpm_user) 
        expect{
          get :new 
        }.to raise_exception(SecurityError)
      } 
    end

    context 'new BriefItem' do
      specify{
        set_current_user(rpm_user) 
        get :new , :brief_id => brief.id
        assigns(:item).should be_a_new(BriefItem)
      }

      specify{
        set_current_user(rpm2_user)
        expect{
          get :new , :brief_id => brief.id
        }.to raise_exception(SecurityError)
      }
    end

    context 'new CheilSolutionItem' do
      specify{
        set_current_user(cheil_user) 
        brief.send_to_cheil!
        get :new , :solution_id => brief.cheil_solution.id
        assigns(:item).should be_a_new(SolutionItem)
      }

      specify{
        set_current_user(cheil2_user)
        brief.send_to_cheil!
        expect{
          get :new , :solution_id => brief.cheil_solution.id
        }.to raise_exception(SecurityError)
      }
    end

    context 'new VendorSolutionItem' do
      specify{
        set_current_user(vendor_user) 
        brief.send_to_cheil!
        vendor_solution = brief.vendor_solutions.create(:org_id=>vendor_user.id)
        get :new , :solution_id => vendor_solution.id
        assigns(:item).should be_a_new(SolutionItem)
      }

      specify{
        set_current_user(vendor2_user)
        brief.send_to_cheil!
        vendor_solution = brief.vendor_solutions.create(:org_id=>vendor_user.id)
        expect{
          get :new , :solution_id => vendor_solution.id
        }.to raise_exception(SecurityError)
      }
    end
  end

  describe 'GET edit' do
    context 'BriefItem' do
      specify{
        set_current_user(rpm_user)
        brief_item = brief.items.create(:name=>'design',:kind=>'design')
        get :edit,:id=>brief_item.id
        assigns(:item).should be_a(BriefItem)
        assigns(:form).should be_nil
      }

      specify{
        set_current_user(rpm2_user)
        brief_item = brief.items.create(:name=>'design',:kind=>'design')
        expect{
          get :edit,:id=>brief_item.id
        }.to raise_exception(SecurityError)
      }
    end

    context 'SolutionItem' do
      #cheil_solution
      specify{
        set_current_user(cheil_user)
        brief.send_to_cheil!
        item = brief.cheil_solution.items.create(:name=>'trans',:kind=>'tran')
        get :edit,:id=>item.id
        assigns(:item).should be_a(SolutionItem)
        assigns(:form).should == 'tran_form'
      }

      specify{
        set_current_user(cheil2_user)
        brief.send_to_cheil!
        item = brief.cheil_solution.items.create(:name=>'trans',:kind=>'tran')
        expect{
          get :edit,:id=>item.id
        }.to raise_exception(SecurityError)
      }
    end

    context 'VendorItem' do
      #vendor_solution
      specify{
        set_current_user(vendor_user)
        vendor_solution = brief.vendor_solutions.create(:org_id=>vendor_user.org_id)
        item = vendor_solution.items.create(:name=>'trans',:kind=>'tran')
        get :edit,:id=>item.id
        assigns(:item).should be_a(SolutionItem)
        assigns(:form).should == 'tran_form'

        get :edit,:id=>item.id,:spec=>'price'
        assigns(:form).should == 'price_form'
      }

      specify{
        set_current_user(vendor2_user)
        vendor_solution = brief.vendor_solutions.create(:org_id=>vendor_user.org_id)
        item = vendor_solution.items.create(:name=>'trans',:kind=>'tran')
        expect{
          get :edit,:id=>item.id
        }.to raise_exception(SecurityError)
      }
    end
  end

  describe 'create' do
    context 'assign a brief_item to a vendor_solution' do
      specify{
        set_current_user(cheil_user)
        brief_item = brief.items.create(:name=>'design1',:kind=>'design')
        brief.send_to_cheil!
        vendor_solution = brief.vendor_solutions.create(:org_id=>vendor_user)
        post :create,:solution_id=>vendor_solution.id,:item_id=>brief_item.id
        vendor_solution.items.find{|e| e.parent_id == brief_item.id}.should_not be_nil
      }

      specify{
        set_current_user(cheil2_user)
        brief_item = brief.items.create(:name=>'design1',:kind=>'design')
        brief.send_to_cheil!
        vendor_solution = brief.vendor_solutions.create(:org_id=>vendor_user)

        expect{
          post :create,:solution_id=>vendor_solution.id,:item_id=>brief_item.id
        }.to raise_exception(SecurityError)
        
        set_current_user(rpm_user)
        expect{
          post :create,:solution_id=>vendor_solution.id,:item_id=>brief_item.id
        }.to raise_exception(SecurityError)

        set_current_user(vendor_user)
        expect{
          post :create,:solution_id=>vendor_solution.id,:item_id=>brief_item.id
        }.to raise_exception(SecurityError)
      }
    end

    context 'wrong params' do
      specify{
        set_current_user(cheil_user)
        brief_item = brief.items.create(:name=>'design1',:kind=>'design')
        brief.send_to_cheil!
        vendor_solution = brief.vendor_solutions.create(:org_id=>vendor_user)
        expect{
          post :create
        }.to raise_exception(SecurityError)
      }
    end

    context 'create a brief_item' do
      specify{
        set_current_user(rpm_user)
        post :create,:brief_id=>brief.id , :brief_item=>{:name=>'design1',:kind=>'design'}
        response.should redirect_to(brief_path(brief))
        brief.items.first.name.should == 'design1'
      }

      specify{
        set_current_user(rpm_user)
        post :create,:brief_id=>brief.id , :brief_item=>{:name=>'',:kind=>'design'}
        response.should render_template('new')
        assigns(:item).should have(1).errors_on(:name)
      }

      specify{
        set_current_user(rpm2_user)
        expect{
          post :create,:brief_id=>brief.id , :brief_item=>{:name=>'design1',:kind=>'design'}
        }.to raise_exception(SecurityError)
      }
    end

    context 'create a solution_item' do
      specify{
        set_current_user(cheil_user)
        brief.send_to_cheil!
        solution = brief.cheil_solution

        post :create,:solution_id=>solution.id,
          :solution_item=>{:name=>'other1',:kind=>'other'}

        response.should redirect_to(solution_path(solution)) 
        assigns(:item).solution.should eq(solution)
      }

      specify{
        set_current_user(cheil_user)
        brief.send_to_cheil!
        solution = brief.cheil_solution

        post :create,:solution_id=>solution.id,
          :solution_item=>{:name=>'',:kind=>'other'}

        response.should render_template('new') 
        assigns(:item).should have(1).errors_on(:name)
      }

      specify{
        set_current_user(cheil2_user)
        brief.send_to_cheil!
        solution = brief.cheil_solution

        expect{
          post :create,:solution_id=>solution.id,
          :solution_item=>{:name=>'other1',:kind=>'other'}
        }.to raise_exception(SecurityError)
      }
    end
  end

  describe 'update' do
    context 'brief_item' do
      specify{
        set_current_user(rpm_user)
        item = brief.items.create(:name=>'ddd',:kind=>'design')
        put :update,:id=>item.id,:brief_item => {:name => 'ppp',:kind => 'product'}

        response.should redirect_to(brief_path(item.fk_id))
        item.reload.name.should == 'ppp'
      }

      specify{
        item = brief.items.create(:name=>'ddd',:kind=>'design')
        set_current_user(rpm2_user)
        expect{
          put :update,:id=>item.id,:brief_item => {:name => 'ppp',:kind => 'product'}
        }.to raise_exception(SecurityError)
      }
    end

    context 'solution_item' do
      specify{
        brief.send_to_cheil!
        set_current_user(cheil_user)

        solution = brief.cheil_solution
        item = solution.items.create(:name=>'ddd',:kind=>'other')
        put :update,:id => item.id,:solution_item => {:name=>'kkk',:kind=>'other'}

        response.should redirect_to(solution_path(item.fk_id))
        item.reload.name.should == 'kkk'
      }

      specify{
        brief.send_to_cheil!
        set_current_user(cheil2_user)

        solution = brief.cheil_solution
        item = solution.items.create(:name=>'ddd',:kind=>'other')
        expect{
          put :update,:id => item.id,:solution_item => {:name=>'kkk',:kind=>'other'}
        }.to raise_exception(SecurityError)
      }
    end
  end
end
=begin
  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested item" do
        item = Item.create! valid_attributes
        # Assuming there are no other items in the database, this
        # specifies that the Item created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Item.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => item.id, :item => {'these' => 'params'}
      end

      it "assigns the requested item as @item" do
        item = Item.create! valid_attributes
        put :update, :id => item.id, :item => valid_attributes
        assigns(:item).should eq(item)
      end

      it "redirects to the item" do
        item = Item.create! valid_attributes
        put :update, :id => item.id, :item => valid_attributes
        response.should redirect_to(item)
      end
    end

    describe "with invalid params" do
      it "assigns the item as @item" do
        item = Item.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Item.any_instance.stub(:save).and_return(false)
        put :update, :id => item.id, :item => {}
        assigns(:item).should eq(item)
      end

      it "re-renders the 'edit' template" do
        item = Item.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Item.any_instance.stub(:save).and_return(false)
        put :update, :id => item.id, :item => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested item" do
      item = Item.create! valid_attributes
      expect {
        delete :destroy, :id => item.id
      }.to change(Item, :count).by(-1)
    end

    it "redirects to the items list" do
      item = Item.create! valid_attributes
      delete :destroy, :id => item.id
      response.should redirect_to(items_url)
    end
  end
=end
