require "spec_helper"

describe BriefCommentsController do
  describe "routing" do

    it "routes to #index" do
      get("/brief_comments").should route_to("brief_comments#index")
    end

    it "routes to #new" do
      get("/brief_comments/new").should route_to("brief_comments#new")
    end

    it "routes to #show" do
      get("/brief_comments/1").should route_to("brief_comments#show", :id => "1")
    end

    it "routes to #edit" do
      get("/brief_comments/1/edit").should route_to("brief_comments#edit", :id => "1")
    end

    it "routes to #create" do
      post("/brief_comments").should route_to("brief_comments#create")
    end

    it "routes to #update" do
      put("/brief_comments/1").should route_to("brief_comments#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/brief_comments/1").should route_to("brief_comments#destroy", :id => "1")
    end

  end
end
