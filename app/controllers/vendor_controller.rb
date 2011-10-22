# encoding: utf-8
class VendorController < ApplicationController
  #检查是否login
  before_filter :vendor_authorize

  #get 'vendor/briefs'=>:briefs,:as=>'vendor_briefs'
  def briefs
    @brief_vendors = BriefVendor.find_all_by_org_id(@cur_user.org_id)
  end

  #get 'vendor/briefs/:id'=>:show_brief,:as=>'vendor_show_brief'
  def show_brief
    @brief = Brief.find(params[:id])
    @brief_vendor = @brief.brief_vendors.find_by_org_id(@cur_user.org_id)
    invalid_op unless @brief_vendor
  end

  #get 'vendor/briefs/:brief_id/items/:item_id/price/edit' =>:item_edit,
  #  :as=>'vendor_edit_price'
  def item_edit_price
    @brief = Brief.find(params[:brief_id])
    @brief_vendor = @brief.brief_vendors.find_by_org_id(@cur_user.org_id)
    invalid_op unless @brief_vendor
    @item = @brief_vendor.items.find_by_id(params[:item_id])
    invalid_op unless @item
  end
end
