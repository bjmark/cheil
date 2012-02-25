require 'spec_helper'

describe CheilSolution do
  describe "cal" do
    let(:brief1){ Brief.create(:name=>'brief1') }
    let(:vendor_solution1){ brief1.vendor_solutions.create }
    let(:vendor_solution2){ brief1.vendor_solutions.create }
    let(:cheil_solution) {brief1.create_cheil_solution}
    
    before do
      vendor_solution1.design_c_sum = 100
      vendor_solution1.product_c_sum = 10
      vendor_solution1.tran_c_sum = 1
      vendor_solution1.other_c_sum = 2
      vendor_solution1.save

      vendor_solution2.design_c_sum = 200
      vendor_solution2.product_c_sum = 20
      vendor_solution2.tran_c_sum = 2
      vendor_solution2.other_c_sum = 4
      vendor_solution2.save
    end

    describe "design_c_sum" do
      it "should == 300" do 
        cheil_solution.cal
        cheil_solution.design_c_sum.should == 300
      end
    end

    describe "product_c_sum" do
      it "should == 30" do 
        cheil_solution.cal
        cheil_solution.product_c_sum.should == 30
      end
    end

    describe "tran_c_sum" do
      it "should == 3" do 
        cheil_solution.cal
        cheil_solution.tran_c_sum.should == 3
      end
    end

    describe "other_c_sum" do
      it "should == 6" do 
        cheil_solution.cal
        cheil_solution.other_c_sum.should == 6
      end
    end
  end
end
