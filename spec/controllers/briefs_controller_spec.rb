require 'spec_helper'

describe BriefsController do
  let(:rpm) { RpmOrg.create(:name=>'rpm') }
  #和rpm_org对应的cheil_org
  let(:cheil) { rpm.create_cheil_org(:name=>'cheil')}

  let(:rpm_user) { rpm.users.create(:name=>'rpm_user',:password=>'123')}
  let(:cheil_user) { cheil.users.create(:name=>'cheil_user',:password=>'123')}

  let(:vendor) { VendorOrg.create(:name=>'vendor')}
  let(:vendor2) { VendorOrg.create(:name=>'vendor2')}

  let(:vendor_user) { vendor.users.create(:name=>'vendor_user',:password=>'123') }

  let(:brief1){ rpm.briefs.create(:name=>'brief1')}

  def set_current_user(user)
    session[:user_id] = user.id
  end

  describe "index" do
    it "return briefs belongs to rpm" do
      set_current_user(rpm_user)
      ret = [brief1]
      get :index
      
      assigns[:briefs].should == ret
      assigns[:nav].should == :rpm

      response.should render_template('index')
    end

    it "return briefs belongs to cheil" do
      set_current_user(cheil_user)
      brief1.cheil_id = cheil.id
      brief1.save
      ret = [brief1]

      get :index

      assigns[:briefs].should == ret
      assigns[:nav].should == :cheil
    end

    it "return briefs which vendor has a solution for" do
      set_current_user(vendor_user)
      vendor_solution = brief1.vendor_solutions.create(:org_id=>vendor.id)
      ret = [brief1]

      get :index

      assigns[:briefs].should == ret
      assigns[:nav].should == :cheil
    end
  end

  describe "not_send" do
    it "return briefs which have not been sent to cheil" do
      set_current_user(rpm_user)
      ret = [brief1]

      get :not_send 

      assigns[:briefs].should == ret
      response.should render_template('not_send')
    end
  end

  describe "search_res" do
    it "return briefs whose name contain 'abc'" do
      set_current_user(rpm_user)
      brief1.name = "brief_abc_123"
      brief1.save

      get :search_res,:name=>'abc',:status=>'all'
      assigns[:briefs].should == [brief1]
    end
  end

  describe "show" do
    specify do 
      set_current_user(rpm_user)
     
      brief1.op_right.add('self',rpm.id,'read')
      brief1.op_right.add('attach',rpm.id,'read')
      brief1.op_right.add('item',rpm.id,'read')
      brief1.op_right.add('comment',rpm.id,'read')
      brief1.op_notice.add(rpm.id)
      brief1.save

      design1 = brief1.items.new(:name=>'design1',:kind=>'design')
      design1.op_right.add('self',[rpm.id,cheil.id,vendor.id],'read')
      design1.save

      product1 = brief1.items.new(:name=>'product1',:kind=>'product')
      product1.op_right.add('self',[rpm.id,cheil.id],'read')
      product1.save

      comment1 = brief1.comments.create(:content=>'abc')

      get :show,:id=>brief1.id

      assigns[:brief].op_notice.include?(rpm.id).should be_false
      assigns[:items].should == [design1,product1]
      assigns[:designs].should == [design1]
      assigns[:products].should == [product1]
      assigns[:comments].should == [comment1]
    end
  end

  describe "create" do
    it "create d brief" do
      set_current_user(rpm_user)
      attr = {:name=>'brief'}

      post :create,:brief => attr

      assigns[:brief].should be_persisted
      assigns[:brief].op_right.check('self',rpm.id,'read').should be_true
      assigns[:brief].op_right.check('self',rpm.id,'update').should be_true
      assigns[:brief].op_right.check('self',rpm.id,'delete').should be_true

      assigns[:brief].op_right.check('attach',rpm.id,'read').should be_true
      assigns[:brief].op_right.check('attach',rpm.id,'update').should be_true
      
      assigns[:brief].op_right.check('item',rpm.id,'read').should be_true
      assigns[:brief].op_right.check('item',rpm.id,'update').should be_true

      assigns[:brief].op_right.check('comment',rpm.id,'read').should be_true
      assigns[:brief].op_right.check('comment',rpm.id,'update').should be_true

      response.should redirect_to(brief_path(assigns[:brief]))
    end
  end

  describe "update" do
    it "notify cheil" do
      set_current_user(rpm_user)
      brief1.op_right.add('self',rpm.id,'update')
      brief1.op_right.add('self',[rpm.id,cheil.id],'read')
      brief1.save

      attr = {:name=>'brief'}

      put :update,:id => brief1.id,:brief => attr

      assigns[:brief].op_notice.include?(cheil.id).should be_true
      response.should redirect_to(brief_path(brief1))
    end
  end

  describe "destroy" do
    it "brief1 should be delete" do
      set_current_user(rpm_user)
      brief1.op_right.add('self',rpm.id,'delete')
      brief1.save
      brief1_id = brief1.id

      delete :destroy,:id=>brief1.id

      Brief.where(:id=>brief1_id).should be_blank
      response.should redirect_to(briefs_url)
    end
  end

  describe "send_to_cheil" do
    it "sent to cheil" do
      set_current_user(rpm_user)
      
      design1 = brief1.items.create(:name => 'design1',:kind=>'design')
      comment1 = brief1.comments.create(:content => 'abc')

      cheil.should == rpm.cheil_org

      put :send_to_cheil,:id => brief1.id

      brief1.reload.op_right.check('self',cheil.id,'read').should be_true
      brief1.op_right.check('self',cheil.id,'update').should be_true

      brief1.op_right.check('attach',cheil.id,'read').should be_true
      brief1.op_right.check('attach',cheil.id,'update').should be_true

      brief1.op_right.check('item',cheil.id,'read').should be_true
      brief1.op_right.check('item',cheil.id,'update').should be_true

      brief1.op_right.check('comment',cheil.id,'read').should be_true
      brief1.op_right.check('comment',cheil.id,'update').should be_true

      brief1.op_right.check('vendor_solution',cheil.id,'read').should be_true
      brief1.op_right.check('vendor_solution',cheil.id,'update').should be_true

      brief1.op_right.check('cheil_solution',cheil.id,'read').should be_true

      brief1.op_notice.include?(cheil.id).should be_true

      brief1.cheil_solution.should_not be_blank

      brief1.items do |e|
        e.op_right.check('self',cheil.id,'read').should be_true
        e.op_right.check('self',cheil.id,'update').should be_true
        e.op_right.check('self',cheil.id,'delete').should be_true
        
        e.op_notice.include?(cheil.id).should be_true
      end

      brief1.comments.each do |e|
        e.op_right.check('self',cheil.id,'read').should be_true
        e.op_notice.include?(cheil.id).should be_true
      end

      response.should redirect_to(brief_path(brief1))
    end
  end

  describe "cancel" do
    specify do 
      set_current_user(rpm_user)
      put :cancel,:id=>brief1.id
      
      brief1.reload.cancel.should == 'y'
      response.should redirect_to(brief_path(brief1))

      put :cancel_cancel,:id=>brief1.id
      brief1.reload.cancel.should == 'n'
      response.should redirect_to(brief_path(brief1))
    end
  end
end
