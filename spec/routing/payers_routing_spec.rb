require "spec_helper"

describe PayersController do
  describe "routing" do

    it "routes to #index" do
      get("/payers").should route_to("payers#index")
    end

    it "routes to #new" do
      get("/payers/new").should route_to("payers#new")
    end

    it "routes to #show" do
      get("/payers/1").should route_to("payers#show", :id => "1")
    end

    it "routes to #edit" do
      get("/payers/1/edit").should route_to("payers#edit", :id => "1")
    end

    it "routes to #create" do
      post("/payers").should route_to("payers#create")
    end

    it "routes to #update" do
      put("/payers/1").should route_to("payers#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/payers/1").should route_to("payers#destroy", :id => "1")
    end

  end
end
