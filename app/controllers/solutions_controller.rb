#encoding=utf-8
class SolutionsController < ApplicationController
  before_filter :cur_user , :check_right

  def check_right
  end

  def show
  end
  #get 'briefs/brief_id/solutions/sel_vendor' => :sel_vendor
  # :as=>sel_vendor_brief_solutions
  def sel_vendor
    #已被选中的vendors
    @brief = Brief.find(params[:brief_id])
    bv = @brief.vendor_solutions
    #所有org去除已被选中的vendor
    @vendors = VendorOrg.all.reject do |e| 
      bv.find{|t| t.org_id == e.id}
    end

    @path = brief_solutions_path(@brief,:back=>@back)

    @title = '选择Vendor'
    render 'share/new_edit'
  end

  def create
    @brief = Brief.find(params[:brief_id])
    vendor_ids = []
    params.each {|k,v| vendor_ids << v if k=~/vendor\d+/}
    vendor_ids.each do |org_id|
      @brief.vendor_solutions << VendorSolution.new(:org_id=>org_id)
    end

    redirect_to params[:back]
  end

  def destroy
    brief = Brief.find(params[:brief_id])
    s = brief.vendor_solutions.find(params[:id])
    s.destroy

    redirect_to params[:back]
  end
end
