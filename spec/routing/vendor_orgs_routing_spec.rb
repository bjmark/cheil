require "spec_helper"

describe VendorOrgsController do
  describe "routing" do

    it "routes to #index" do
      get("/vendor_orgs").should route_to("vendor_orgs#index")
    end

    it "routes to #new" do
      get("/vendor_orgs/new").should route_to("vendor_orgs#new")
    end

    it "routes to #show" do
      get("/vendor_orgs/1").should route_to("vendor_orgs#show", :id => "1")
    end

    it "routes to #edit" do
      get("/vendor_orgs/1/edit").should route_to("vendor_orgs#edit", :id => "1")
    end

    it "routes to #create" do
      post("/vendor_orgs").should route_to("vendor_orgs#create")
    end

    it "routes to #update" do
      put("/vendor_orgs/1").should route_to("vendor_orgs#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/vendor_orgs/1").should route_to("vendor_orgs#destroy", :id => "1")
    end

  end
end
