#coding=utf-8
require 'spec_helper'

describe BriefItemsController do
  let(:rpm) { RpmOrg.create(:name=>'rpm') }
  #和rpm_org对应的cheil_org
  let(:cheil) { rpm.create_cheil_org(:name=>'cheil')}

  let(:rpm_user) { rpm.users.create(:name=>'rpm_user',:password=>'123')}
  let(:cheil_user) { cheil.users.create(:name=>'cheil_user',:password=>'123')}
  
  let(:vendor) { VendorOrg.create(:name=>'vendor')}
  let(:vendor2) { VendorOrg.create(:name=>'vendor2')}

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
        response.should render_template('edit')
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

      response.should redirect_to(brief_path(brief1))
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

      response.should redirect_to(brief_path(brief1))
    end
  end

  describe "create_many" do
    let(:attr) do 
      {
        'name_0' => 'name_1',
        'quantity_0' => 'quantity_1',
        'note_0' => 'note_1',
        'kind_0' => 'design',
        'name_1' => '',
        'quantity_1' => '',
        'note_1' => '',
        'kind_1' => '',
        'name_2' => 'name_2',
        'quantity_2' => 'quantity_2',
        'note_2' => 'note_2',
        'kind_2' => 'product'
      }
    end
    context "save_many" do
      it "should raise exception if user has no update right on the brief" do
        set_current_user(rpm_user)
        expect {
          post  :create_many,:save_many=>'abc',:brief_id=>brief1.id
        }.to raise_exception(SecurityError)
      end

      it "should create 2 items" do
        set_current_user(rpm_user)
        brief1.op_right.add('item',[rpm.id,cheil.id],'update')
        brief1.save

        expect {
          post :create_many,:save_many => 'abc',:brief_id => brief1.id,:brief_item => attr
        }.to change { brief1.reload.items.size }.from(0).to(2)

        response.should redirect_to(brief_path(brief1))
      end

      it "cheil should has read update delete right for the new items" do
        set_current_user(rpm_user)
        brief1.op_right.add('item',[rpm.id,cheil.id],'update')
        brief1.save

        post :create_many,:save_many => 'abc',:brief_id => brief1.id,:brief_item => attr

        brief1.items.size.should == 2 
        brief1.items.each do |m| 
          m.op_right.check('self',cheil.id,'read').should be_true
          m.op_right.check('self',cheil.id,'update').should be_true
          m.op_right.check('self',cheil.id,'delete').should be_true
        end
      end

      it "cheil should be notify for the new items,and change of the brief" do
        set_current_user(rpm_user)
        brief1.op_right.add('item',[rpm.id,cheil.id],'update')
        brief1.save

        post :create_many,:save_many => 'abc',:brief_id => brief1.id,:brief_item => attr

        brief1.items.size.should == 2 
        brief1.items.each do |m|
          m.op_notice.include?(cheil.id).should be_true
        end

        brief1.reload.op_notice.include?(cheil.id).should be_true
      end
    end

    context "add_5_design" do
      it "kind_default should be design" do
        set_current_user(rpm_user)
        brief1.op_right.add('item',[rpm.id,cheil.id],'update')
        brief1.save

        post :create_many,:add_5_design => 'add_5_design',:brief_id => brief1.id,:brief_item => attr

        assigns[:kind_default].should == 'design'

        response.should render_template('new_many')
      end

      it "item_count should be 8" do
        set_current_user(rpm_user)
        brief1.op_right.add('item',[rpm.id,cheil.id],'update')
        brief1.save

        post :create_many,:add_5_product => 'add_5_product',:brief_id => brief1.id,:brief_item => attr

        assigns[:kind_default].should == 'product'
        assigns[:item_count].should == 8
      end
    end
  end

  describe "update_many" do
    it "update 2 items,notify cheil and vendor and vendor2" do
      set_current_user(rpm_user)
      brief1.op_right.add('item',rpm.id,'update')
      brief1.save

      item1 = brief1.items.create(:name=>'design1')
      item1.op_right.add('self',[rpm.id,cheil.id,vendor.id],'read')
      item1.save

      item2 = brief1.items.create(:name=>'product1')
      item2.op_right.add('self',[rpm.id,cheil.id,vendor2.id],'read')
      item2.save

      brief1.items.size.should == 2

      attr = {
        "name_#{item1.id}" => "name_#{item1.id}",
        "quantity_#{item1.id}" => "quantity_#{item1.id}",
        "note_#{item1.id}" => "note_#{item1.id}",
        "kind_#{item1.id}" => "design",
        "name_#{item2.id}" => "name_#{item2.id}",
        "quantity_#{item2.id}" => "quantity_#{item2.id}",
        "note_#{item2.id}" => "note_#{item2.id}",
        "kind_#{item2.id}" => "product"
      }

      put :update_many,:brief_id => brief1.id,:brief_item => attr

      item1.reload.name.should == "name_#{item1.id}"
      item1.quantity.should == "quantity_#{item1.id}"
      item1.note.should == "note_#{item1.id}"
      item1.kind.should == "design"

      item2.reload.name.should == "name_#{item2.id}"
      item2.quantity.should == "quantity_#{item2.id}"
      item2.note.should == "note_#{item2.id}"
      item2.kind.should == "product"

      item1.op_notice.include?(cheil.id).should be_true
      item1.op_notice.include?(vendor.id).should be_true

      item2.op_notice.include?(cheil.id).should be_true
      item2.op_notice.include?(vendor2.id).should be_true

      brief1.reload.op_notice.include?(cheil.id).should be_true
      brief1.op_notice.include?(vendor.id).should be_true
      brief1.op_notice.include?(vendor2.id).should be_true

      response.should redirect_to(brief_path(brief1))
    end
  end
end
