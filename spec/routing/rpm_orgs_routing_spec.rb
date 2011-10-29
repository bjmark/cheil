require "spec_helper"

describe RpmOrgsController do
  describe "routing" do

    it "routes to #index" do
      get("/rpm_orgs").should route_to("rpm_orgs#index")
    end

    it "routes to #new" do
      get("/rpm_orgs/new").should route_to("rpm_orgs#new")
    end

    it "routes to #show" do
      get("/rpm_orgs/1").should route_to("rpm_orgs#show", :id => "1")
    end

    it "routes to #edit" do
      get("/rpm_orgs/1/edit").should route_to("rpm_orgs#edit", :id => "1")
    end

    it "routes to #create" do
      post("/rpm_orgs").should route_to("rpm_orgs#create")
    end

    it "routes to #update" do
      put("/rpm_orgs/1").should route_to("rpm_orgs#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/rpm_orgs/1").should route_to("rpm_orgs#destroy", :id => "1")
    end

  end
end
