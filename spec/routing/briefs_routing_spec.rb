require "spec_helper"

describe BriefsController do
  describe "routing" do

    it "routes to #index" do
      get("/briefs").should route_to("briefs#index")
    end

    it "routes to #new" do
      get("/briefs/new").should route_to("briefs#new")
    end

    it "routes to #show" do
      get("/briefs/1").should route_to("briefs#show", :id => "1")
    end

    it "routes to #edit" do
      get("/briefs/1/edit").should route_to("briefs#edit", :id => "1")
    end

    it "routes to #create" do
      post("/briefs").should route_to("briefs#create")
    end

    it "routes to #update" do
      put("/briefs/1").should route_to("briefs#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/briefs/1").should route_to("briefs#destroy", :id => "1")
    end

  end
end
