require "spec_helper"

describe AttachesController do
  describe "routing" do

    it "routes to #index" do
      get("/attaches").should route_to("attaches#index")
    end

    it "routes to #new" do
      get("/attaches/new").should route_to("attaches#new")
    end

    it "routes to #show" do
      get("/attaches/1").should route_to("attaches#show", :id => "1")
    end

    it "routes to #edit" do
      get("/attaches/1/edit").should route_to("attaches#edit", :id => "1")
    end

    it "routes to #create" do
      post("/attaches").should route_to("attaches#create")
    end

    it "routes to #update" do
      put("/attaches/1").should route_to("attaches#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/attaches/1").should route_to("attaches#destroy", :id => "1")
    end

  end
end
