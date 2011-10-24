require "spec_helper"

describe VendorController do
  describe "routing" do

    #get 'vendor/briefs/:brief_id/items/new/(:kind)' => :item_new,
    #    :as=>'vendor_item_new'
    it "routes to #item_new" do
      get("/vendor/briefs/1/items/new").should route_to("vendor#item_new",:brief_id=>'1')
    end

    it "routes to #item_new" do
      get("/vendor/briefs/1/items/new/trans").should route_to("vendor#item_new",:brief_id=>'1',:kind=>'trans')
    end

    #get 'vendor/briefs/:brief_id/items/:item_id/edit' => :item_edit,
    #  :as=>'vendor_item_edit'
    it "routes to #item_edit" do
      get("/vendor/briefs/1/items/2/edit").should route_to("vendor#item_edit",:brief_id=>'1',:item_id=>'2')
    end
  end


  #put 'vendor/briefs/:brief_id/items/:item_id' => :item_update,
  #  :as=>'vendor_item_update'
  it "routes to #item_update" do
    put("/vendor/briefs/1/items/2").should route_to("vendor#item_update",:brief_id=>'1',:item_id=>'2')
  end


  #post 'vendor/briefs/:brief_id/items' => :item_create,
  #  :as=>'vendor_item_create'
  it "routes to #item_create" do
    post("/vendor/briefs/1/items").should route_to("vendor#item_create",:brief_id=>'1')
  end

  #delete 'vendor/briefs/:brief_id/items/:item_id' => :item_del,
  #  :as=>'vendor_item_del'
  it "routes to #item_del" do
    delete("/vendor/briefs/1/items/2").should route_to("vendor#item_del",:brief_id=>'1',:item_id=>'2')
  end
end
