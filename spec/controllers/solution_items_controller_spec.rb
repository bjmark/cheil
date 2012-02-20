require 'spec_helper'

describe SolutionItemsController do
  let(:rpm) { RpmOrg.create(:name=>'rpm') }
  #和rpm_org对应的cheil_org
  let(:cheil) { rpm.create_cheil_org(:name=>'cheil')}

  let(:rpm_user) { rpm.users.create(:name=>'rpm_user',:password=>'123')}
  let(:cheil_user) { cheil.users.create(:name=>'cheil_user',:password=>'123')}

  let(:vendor) { VendorOrg.create(:name=>'vendor')}
  let(:vendor2) { VendorOrg.create(:name=>'vendor2')}
  
  let(:vendor_user) {vendor.users.create(:name=>'vendor_user',:password=>'123')}

  let(:brief1){ rpm.briefs.create(:name=>'brief1')}

  def set_current_user(user)
    session[:user_id] = user.id
  end

  describe 'create_many' do
    context 'save_many' do
      specify do
        set_current_user(vendor_user)
        vs = brief1.vendor_solutions.new(:org_id=>vendor.id)
        vs.op_right.add('item',vendor.id,'read','create_tran_other')
        vs.op_right.add('item',cheil.id,'read')
        vs.save

        brief1.cheil_id = cheil.id
        brief1.save

        new_items = {
          'name_0'=>'name_0',
          'quantity_0'=>'10',
          'note_0'=>'note_0',
          'price_0'=>'10',
          'tax_rate_0'=>'0.03',
          'kind_0'=>'tran',

          'name_1'=>'',
          'quantity_1'=>'',
          'note_1'=>'',
          'price_1'=>'',
          'tax_rate_1'=>'',
          'kind_1'=>'',

          'name_2'=>'name_0',
          'quantity_2'=>'10',
          'note_2'=>'abc',
          'price_2'=>'10',
          'tax_rate_2'=>'0.03',
          'kind_2'=>'tran'
        }

        post :create_many,{:save_many=>'abc',:solution_id=>vs.id}.merge(new_items)

        vs.reload.items.size.should == 2
        item1 = vs.items.first
        item1.name.should == 'name_0'
        item1.quantity.should == '10'
        item1.note.should == 'note_0'
        item1.price.should == '10'
        item1.tax_rate.should == '0.03'
        item1.kind.should == 'tran'
        item1.tax.should == '3'
        item1.total_up.should == '100'
        item1.total_up_tax.should == '103'

        item1.op_right.check('self',vendor.id,'read').should be_true
        item1.op_right.check('self',vendor.id,'update').should be_true
        item1.op_right.check('self',vendor.id,'delete').should be_true

        item1.op_right.check('self',cheil.id,'read').should be_true
        item1.op_right.check('self',cheil.id,'check').should be_true

        item1.op_notice.include?(cheil.id).should be_true
        brief1.reload.op_notice.include?(cheil.id).should be_true

        response.should redirect_to(vendor_solution_path(vs))
      end
    end
  end

  describe 'update_price' do
    specify do
      set_current_user(vendor_user)
      solution = brief1.vendor_solutions.create(:org_id=>vendor.id)

      item = solution.items.new(:name=>'d1',:quantity=>'10')
      item.op_right.add('self',vendor.id,'price')
      item.op_right.add('self',[cheil.id,vendor.id],'read')
      item.save

      solution_item = {
        'note'=>'note',
        'price'=>'10',
        'tax_rate'=>'0.03'
      }

      put :update_price,:id=>item.id,:solution_item=>solution_item

      item.reload.note.should == 'note'
      item.price.should =='10'
      item.total_up.should == '100'
      item.tax_rate.should == '0.03'
      item.tax.should == '3'
      item.total_up_tax.should == '103'

      item.op_notice.include?(cheil.id).should be_true

      solution.reload.op_notice.include?(cheil.id).should be_true

      brief1.reload.op_notice.include?(cheil.id).should be_true

      response.should redirect_to(vendor_solution_path(solution))
    end
  end

  describe 'edit_price_many' do
    specify do
      set_current_user(vendor_user)
      solution = brief1.vendor_solutions.new(:org_id=>vendor.id)
      solution.op_right.add('item',vendor.id,'price_design_product')
      solution.save

      d1 = solution.items.create(:name=>'d1',:kind=>'design')
      d2 = solution.items.create(:name=>'d2',:kind=>'design')
      p1 = solution.items.create(:name=>'p1',:kind=>'product')
      t1 = solution.items.create(:name=>'t1',:kind=>'tran')

      get :edit_price_many,:solution_id=>solution.id

      assigns[:items].should == [d1,d2,p1]

      response.should render_template('edit_price_many')
    end
  end

  describe 'update_price_many' do
    specify do
      set_current_user(vendor_user)
      solution = brief1.vendor_solutions.new(:org_id=>vendor.id)
      solution.op_right.add('item',vendor.id,'price_design_product')
      solution.save

      d1 = solution.items.new(:name=>'d1',:quantity=>'10',:kind=>'design')
      d1.op_right.add('self',[cheil.id,vendor.id],'read')
      d1.save

      d2 = solution.items.new(:name=>'d2',:quantity=>'10',:kind=>'design')
      d2.op_right.add('self',[cheil.id,vendor.id],'read')
      d2.save

      p1 = solution.items.new(:name=>'p1',:quantity=>'10',:kind=>'product')
      p1.op_right.add('self',[cheil.id,vendor.id],'read')
      p1.save

      solution_item = {
        "note_#{d1.id}" => "note_1",
        "price_#{d1.id}" => '10',
        "tax_rate_#{d1.id}" => '0.05',
        
        "note_#{d2.id}" => "note_1",
        "price_#{d2.id}" => '10',
        "tax_rate_#{d2.id}" => '0.03',

        "note_#{p1.id}" => "note_p",
        "price_#{p1.id}" => '10',
        "tax_rate_#{p1.id}" => '0.03'
      }

      put :update_price_many,:solution_id=>solution.id,:solution_item=>solution_item

      brief1.reload.op_notice.include?(cheil.id).should be_true
      brief1.op_notice.read.should == [cheil.id.to_s]

      solution.reload.op_notice.include?(cheil.id).should be_true

      p1.reload.note.should == 'note_p'
      p1.price.should == '10'
      p1.tax_rate.should == '0.03'
      p1.tax.should == '3'
      p1.total_up.should == '100'
      p1.total_up_tax.should == '103'

      response.should redirect_to(vendor_solution_path(solution))
    end
  end

  describe 'edit_many' do
    specify do
      set_current_user(vendor_user)
      solution = brief1.vendor_solutions.create(:org_id=>vendor.id)
      d1 = solution.items.create(:name=>'d1',:kind=>'design')

      tran1 = solution.items.new(:name=>'tran1',:kind=>'tran')
      tran1.op_right.add('self',vendor.id,'update')
      tran1.save
      
      other1 = solution.items.new(:name=>'other1',:kind=>'other')
      other1.op_right.add('self',vendor.id,'update')
      other1.save

      get :edit_many,:solution_id=>solution.id

      assigns[:items].should == [tran1,other1]
    end
  end
end
