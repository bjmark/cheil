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
    @action_to = vendor_item_update_price_path
  end

  #put 'vendor/briefs/:brief_id/items/:item_id/price/update' =>:item_update_price,
  #  :as=>'vendor_item_update_price'
  def item_update_price
    @brief = Brief.find(params[:brief_id])
    @brief_vendor = @brief.brief_vendors.find_by_org_id(@cur_user.org_id)
    invalid_op unless @brief_vendor
    @item = @brief_vendor.items.find_by_id(params[:item_id])
    invalid_op unless @item
    
    @item.price = params[:item][:price]
    @item.save

    redirect_to vendor_show_brief_path(@brief)

  end

  #get 'vendor/briefs/:brief_id/items/new/(:kind)' => :item_new,
  #    :as=>'vendor_item_new'
  def item_new
    @brief = Brief.find(params[:brief_id])
    @item = Item.new
    @item.kind = params[:kind]
    @action_to = vendor_item_create_path(@brief,@item.kind)
  end

  #get 'vendor/briefs/:brief_id/items/edit' => :item_edit,
  #    :as=>'vendor_item_edit'
  def item_edit
  end

  #post 'vendor/briefs/:brief_id/items/(:kind)' => :item_create,
  #    :as=>'vendor_item_create'
  def item_create
    @brief = Brief.find(params[:brief_id])
    @brief_vendor = @brief.brief_vendors.find_by_org_id(@cur_user.org_id)
    invalid_op unless @brief_vendor
    @brief_vendor.items << Item.new(params[:item]){|r|r.kind = params[:kind]}
    redirect_to vendor_show_brief_path(@brief)
  end
end
