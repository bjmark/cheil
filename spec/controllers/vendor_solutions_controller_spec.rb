require 'spec_helper'

describe VendorSolutionsController do
  let(:rpm) { RpmOrg.create(:name=>'rpm') }
  #和rpm_org对应的cheil_org
  let(:cheil) { rpm.create_cheil_org(:name=>'cheil')}

  let(:rpm_user) { rpm.users.create(:name=>'rpm_user',:password=>'123')}
  let(:cheil_user) { cheil.users.create(:name=>'cheil_user',:password=>'123')}

  let(:vendor) { VendorOrg.create(:name=>'vendor') }
  let(:vendor2) { VendorOrg.create(:name=>'vendor2') }

  let(:brief1){ rpm.briefs.create(:name=>'brief1')}

  def set_current_user(user)
    session[:user_id] = user.id
  end

  describe 'new_many' do
    specify do 
      set_current_user(cheil_user)

      brief1.cheil_id = cheil.id
      brief1.save
      vendor_solution1 = brief1.vendor_solutions.create(:org_id=>vendor.id)
      all_vendors = [vendor,vendor2]

      get :new_many,:brief_id=>brief1.id

      assigns[:brief].should == brief1
      assigns[:vendors].should == [cheil,vendor2]

      response.should render_template('new_many')
    end
  end

  describe 'create_many' do
    specify do
      set_current_user(cheil_user)
      brief1.op_right.add('vendor_solution',cheil.id,'update')
      brief1.save

      brief1.attaches.create
      brief1.attaches.create

      brief1.attaches.size.should == 2

      vendor3 = VendorOrg.create(:name=>'vendor3')
      vendor4 = VendorOrg.create(:name=>'vendor4')

      all_vendors = [vendor,vendor2,vendor3,vendor4]

      selected_vendors = { 
        "vendor#{vendor.id}"=>vendor.id,
        "vendor#{vendor2.id}"=>vendor2.id,
        "vendor#{vendor3.id}"=>vendor3.id,
        "vendor#{vendor4.id}"=>vendor4.id
      }

      post :create_many,{:brief_id=>brief1.id}.merge(selected_vendors)

      brief1.vendor_solutions.size.should == 4
      (vendor_solution1 = brief1.vendor_solutions.where(:org_id=>vendor.id).first).should_not  be_blank
      
      vendor_solution1.op_right.check('self',brief1.cheil_id,'read').should be_true
      vendor_solution1.op_right.check('self',brief1.cheil_id,'delete').should be_true
      vendor_solution1.op_right.check('attach',brief1.cheil_id,'read').should be_true
      vendor_solution1.op_right.check('item',brief1.cheil_id,'read').should be_true
      vendor_solution1.op_right.check('item',brief1.cheil_id,'add_brief_item').should be_true
      vendor_solution1.op_right.check('comment',brief1.cheil_id,'read').should be_true
      vendor_solution1.op_right.check('comment',brief1.cheil_id,'update').should be_true

      vendor_solution1.op_right.check('self',vendor.id,'read').should be_true
      vendor_solution1.op_right.check('attach',vendor.id,'read').should be_true
      vendor_solution1.op_right.check('attach',vendor.id,'update').should be_true
      vendor_solution1.op_right.check('item',vendor.id,'read').should be_true
      vendor_solution1.op_right.check('item',vendor.id,'create_tran_other').should be_true
      vendor_solution1.op_right.check('item',vendor.id,'price_design_product').should be_true
      vendor_solution1.op_right.check('comment',vendor.id,'read').should be_true
      vendor_solution1.op_right.check('comment',vendor.id,'update').should be_true

      brief1.reload.op_right.check('self',vendor.id,'read').should be_true
      brief1.op_right.check('attach',vendor.id,'read').should be_true
      brief1.op_right.check('item',vendor.id,'read').should be_true

      brief1.op_notice.include?(vendor.id).should be_true

      brief1.attaches.each do |e|
        e.op_right.check('self',vendor.id,'read').should be_true
        e.op_notice.include?(vendor.id).should be_true
      end
      response.should redirect_to vendor_solutions_path(:brief_id=>brief1.id)
    end
  end

  describe 'destroy' do
    specify do
      set_current_user(cheil_user)
      vendor_solution1 = brief1.vendor_solutions.new(:org_id=>vendor.id)
      vendor_solution1.op_right.add('self',cheil.id,'delete')
      vendor_solution1.save

      vs_id = vendor_solution1.id

      brief1.op_right.add('self',vendor.id,'read')
      brief1.op_right.add('attach',vendor.id,'read')
      brief1.op_right.add('item',vendor.id,'read')
      brief1.save

      2.times do
        a = brief1.attaches.new
        a.op_right.add('self',vendor.id,'read')
        a.save
      end
      brief1.attaches.size.should == 2

      3.times do |e|
        i = brief1.items.new(:name=>"item#{e}")
        i.op_right.add('self',vendor.id,'read')
        i.save
      end
      brief1.items.size.should == 3

      delete :destroy,:id=>vendor_solution1.id

      VendorSolution.where(:id=>vs_id).should be_blank

      brief1.reload.op_right.check('self',vendor.id,'read').should be_false
      brief1.reload.op_right.check('attach',vendor.id,'read').should be_false
      brief1.reload.op_right.check('item',vendor.id,'read').should be_false

      brief1.attaches do |e|
        e.op_right.check('self',vendor.id,'read').should be_false
      end

      brief1.items.each do |e|
        e.op_right.check('self',vendor.id,'read').should be_false
      end

      response.should redirect_to(vendor_solutions_path(:brief_id=>brief1.id))
    end
  end

  describe 'add_brief_item' do
    specify do
      set_current_user(cheil_user)
      design1 = brief1.items.create(:name=>'design1',:kind=>'design')
      vendor_solution1 = brief1.vendor_solutions.new(:org_id=>vendor.id)
      vendor_solution1.op_right.add('item',cheil.id,'add_brief_item')
      vendor_solution1.save

      post :add_brief_item,:id=>vendor_solution1.id,:brief_item_id=>design1.id

      (item = vendor_solution1.items.where(:parent_id=>design1.id).first).should_not be_blank
      item.op_right.check('self',cheil.id,'read').should be_true
      item.op_right.check('self',cheil.id,'del_brief_item').should be_true
      item.op_right.check('self',cheil.id,'check').should be_true

      item.op_right.check('self',vendor.id,'read').should be_true
      item.op_right.check('self',vendor.id,'price').should be_true

      item.op_notice.include?(vendor.id).should be_true

      item.brief_item.op_notice.include?(vendor.id).should be_true
      item.brief_item.op_right.check('self',vendor.id,'read').should be_true

      brief1.reload.op_notice.include?(vendor.id).should be_true

      response.should redirect_to(pick_brief_items_vendor_solution_path(vendor_solution1))
    end
  end

  describe 'del_brief_item' do
    specify do
      set_current_user(cheil_user)
      design1 = brief1.items.new(:name=>'design1',:kind=>'design')
      design1.op_right.add('self',vendor.id,'read')
      design1.save
      
      vendor_solution1 = brief1.vendor_solutions.create(:org_id=>vendor.id)
      
      item = vendor_solution1.items.new(:parent_id=>design1.id)
      item.op_right.add('self',cheil.id,'del_brief_item')
      item.save

      delete :del_brief_item,:id=>vendor_solution1.id,:brief_item_id=>design1.id

      vendor_solution1.reload.items.should be_blank
      design1.reload.op_right.check('self',vendor.id,'read').should be_false

      response.should redirect_to(pick_brief_items_vendor_solution_path(vendor_solution1))
    end
  end
end
