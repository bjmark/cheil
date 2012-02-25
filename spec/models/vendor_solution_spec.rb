require 'spec_helper'

describe VendorSolution do
  #pending "add some examples to (or delete) #{__FILE__}"
  describe "cal" do
    let(:brief1){ Brief.create(:name=>'brief1') }
    let(:d1){ brief1.items.create(:name=>'design1',:quantity=>'10',:kind=>'design') }
    let(:d2){ brief1.items.create(:name=>'design2',:quantity=>'20',:kind=>'design') }
    let(:p1){ brief1.items.create(:name=>'p1',:quantity=>'100',:kind=>'product') }
    let(:p2){ brief1.items.create(:name=>'p2',:quantity=>'200',:kind=>'product') }

    let(:vendor_solution1){ brief1.vendor_solutions.create }

    before do
      vendor_solution1.items.new(:parent_id=>d1.id,:price=>'10',:tax_rate=>'0.03',:checked=>'y').cal_save
      vendor_solution1.items.new(:parent_id=>d2.id,:price=>'15',:tax_rate=>'0.1',:checked=>'y').cal_save

      vendor_solution1.items.new(:parent_id=>p1.id,:price=>'10',:tax_rate=>'0.03',:checked=>'y').cal_save
      vendor_solution1.items.new(:parent_id=>p2.id,:price=>'15',:tax_rate=>'0.1',:checked=>'y').cal_save

      vendor_solution1.items.new do |e|
        e.name = 'tran1'
        e.quantity = '5'
        e.price = '10'
        e.tax_rate = '0.1'
        e.kind = 'tran'
        e.checked = 'y'
        e.cal_save
      end

      vendor_solution1.items.new do |e|
        e.name = 'other1'
        e.quantity = '5'
        e.price = '10'
        e.tax_rate = '0.1'
        e.kind = 'other'
        e.checked = 'y'
        e.cal_save
      end

      vendor_solution1.items.new do |e|
        e.name = 'other2'
        e.quantity = '10'
        e.price = '10'
        e.tax_rate = '0.1'
        e.kind = 'other'
        e.checked = 'y'
        e.cal_save
      end
    end

    describe "design_sum" do
      it "should == 400" do
        vendor_solution1.designs.size.should == 2
        vendor_solution1.cal
        vendor_solution1.design_sum.should == 400
      end
    end

    describe "product_sum" do
      it "should == 4000" do
        vendor_solution1.products.size.should == 2
        vendor_solution1.cal
        vendor_solution1.product_sum.should == 4000
      end
    end

    describe "tran_sum" do
      it "should == 50 " do
        vendor_solution1.trans.size.should == 1
        vendor_solution1.cal
        vendor_solution1.tran_sum.should == 50
      end
    end

    describe "other_sum" do
      it "should == 150 " do
        vendor_solution1.others.size.should == 2
        vendor_solution1.cal
        vendor_solution1.other_sum.should == 150
      end
    end

    describe "design_tax_sum" do
      it "should == 33" do 
        vendor_solution1.cal
        vendor_solution1.design_tax_sum.should == 33
      end
    end

    describe "product_tax_sum" do
      it "should == 330" do 
        vendor_solution1.cal
        vendor_solution1.product_tax_sum.should == 330
      end
    end

    describe "tran_tax_sum" do
      it "should == 5" do 
        vendor_solution1.cal
        vendor_solution1.tran_tax_sum.should == 5
      end
    end

    describe "other_tax_sum" do
      it "should == 15" do 
        vendor_solution1.cal
        vendor_solution1.other_tax_sum.should == 15
      end
    end

    describe "design_and_tax_sum" do
      it "should == 433" do 
        vendor_solution1.cal
        vendor_solution1.design_and_tax_sum.should == 433
      end
    end

    describe "product_and_tax_sum" do
      it "should == 4330" do 
        vendor_solution1.cal
        vendor_solution1.product_and_tax_sum.should == 4330
      end
    end

    describe "tran_and_tax_sum" do
      it "should == 55" do 
        vendor_solution1.cal
        vendor_solution1.tran_and_tax_sum.should == 55
      end
    end

    describe "other_and_tax_sum" do
      it "should == 165" do 
        vendor_solution1.cal
        vendor_solution1.other_and_tax_sum.should == 165
      end
    end

    describe "all_sum" do
      it "should == 4600" do 
        vendor_solution1.cal
        vendor_solution1.all_sum.should == 4600
      end
    end

    describe "all_tax_sum" do
      it "should == 383" do 
        vendor_solution1.cal
        vendor_solution1.all_tax_sum.should == 383
      end
    end

    describe "all_and_tax_sum" do
      it "should == 4983" do 
        vendor_solution1.cal
        vendor_solution1.all_and_tax_sum.should == 4983
      end
    end

    describe "design_c_sum" do
      it "should == 400" do
        vendor_solution1.cal
        vendor_solution1.design_c_sum.should == 400
      end
    end

    describe "product_c_sum" do
      it "should == 4000" do
        vendor_solution1.cal
        vendor_solution1.product_sum.should == 4000
      end
    end

    describe "tran_c_sum" do
      it "should == 50 " do
        vendor_solution1.cal
        vendor_solution1.tran_c_sum.should == 50
      end
    end

    describe "other_c_sum" do
      it "should == 150 " do
        vendor_solution1.cal
        vendor_solution1.other_c_sum.should == 150
      end
    end

    describe "design_c_tax_sum" do
      it "should == 33" do 
        vendor_solution1.cal
        vendor_solution1.design_c_tax_sum.should == 33
      end
    end

    describe "product_c_tax_sum" do
      it "should == 330" do 
        vendor_solution1.cal
        vendor_solution1.product_c_tax_sum.should == 330
      end
    end

    describe "tran_c_tax_sum" do
      it "should == 5" do 
        vendor_solution1.cal
        vendor_solution1.tran_c_tax_sum.should == 5
      end
    end

    describe "other_c_tax_sum" do
      it "should == 15" do 
        vendor_solution1.cal
        vendor_solution1.other_c_tax_sum.should == 15
      end
    end

    describe "design_c_and_tax_sum" do
      it "should == 433" do 
        vendor_solution1.cal
        vendor_solution1.design_c_and_tax_sum.should == 433
      end
    end

    describe "product_c_and_tax_sum" do
      it "should == 4330" do 
        vendor_solution1.cal
        vendor_solution1.product_c_and_tax_sum.should == 4330
      end
    end

    describe "tran_c_and_tax_sum" do
      it "should == 55" do 
        vendor_solution1.cal
        vendor_solution1.tran_c_and_tax_sum.should == 55
      end
    end

    describe "other_c_and_tax_sum" do
      it "should == 165" do 
        vendor_solution1.cal
        vendor_solution1.other_c_and_tax_sum.should == 165
      end
    end

    describe "all_c_sum" do
      it "should == 4600" do 
        vendor_solution1.cal
        vendor_solution1.all_c_sum.should == 4600
      end
    end

    describe "all_c_tax_sum" do
      it "should == 383" do 
        vendor_solution1.cal
        vendor_solution1.all_c_tax_sum.should == 383
      end
    end

    describe "all_c_and_tax_sum" do
      it "should == 4983" do 
        vendor_solution1.cal
        vendor_solution1.all_c_and_tax_sum.should == 4983
      end
    end
  end
end
