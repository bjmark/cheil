class VendorStatController < ApplicationController
  before_filter :cur_user  

  def check_right
    invalid_op if !@cur_user.org.instance_of?(CheilOrg)
  end

  def index
    @vendor_orgs = VendorOrg.all

    @vendor_orgs.each do |v|
      v.brief_count = 0
      v.money_sum = 0
      VendorSolution.where(:org_id=>v.id).all.each do |s|
        v.brief_count += 1
        v.money_sum += s.all_c_and_tax_sum
      end
      v.save
    end

  end

  def show
    @vendor = VendorOrg.find(params[:id])
    @vendor_solutions = VendorSolution.where(:org_id=>@vendor.id)
  end
end
