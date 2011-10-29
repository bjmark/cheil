require "spec_helper"

describe CheilOrgsController do
  describe "routing" do

    it "routes to #index" do
      get("/cheil_orgs").should route_to("cheil_orgs#index")
    end

    it "routes to #new" do
      get("/cheil_orgs/new").should route_to("cheil_orgs#new")
    end

    it "routes to #show" do
      get("/cheil_orgs/1").should route_to("cheil_orgs#show", :id => "1")
    end

    it "routes to #edit" do
      get("/cheil_orgs/1/edit").should route_to("cheil_orgs#edit", :id => "1")
    end

    it "routes to #create" do
      post("/cheil_orgs").should route_to("cheil_orgs#create")
    end

    it "routes to #update" do
      put("/cheil_orgs/1").should route_to("cheil_orgs#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/cheil_orgs/1").should route_to("cheil_orgs#destroy", :id => "1")
    end

  end
end
