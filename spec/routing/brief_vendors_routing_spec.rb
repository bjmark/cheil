require "spec_helper"

describe BriefVendorsController do
  describe "routing" do

    it "routes to #index" do
      get("/brief_vendors").should route_to("brief_vendors#index")
    end

    it "routes to #new" do
      get("/brief_vendors/new").should route_to("brief_vendors#new")
    end

    it "routes to #show" do
      get("/brief_vendors/1").should route_to("brief_vendors#show", :id => "1")
    end

    it "routes to #edit" do
      get("/brief_vendors/1/edit").should route_to("brief_vendors#edit", :id => "1")
    end

    it "routes to #create" do
      post("/brief_vendors").should route_to("brief_vendors#create")
    end

    it "routes to #update" do
      put("/brief_vendors/1").should route_to("brief_vendors#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/brief_vendors/1").should route_to("brief_vendors#destroy", :id => "1")
    end

  end
end
