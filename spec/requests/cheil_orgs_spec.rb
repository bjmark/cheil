require 'spec_helper'

describe "CheilOrgs" do
  describe "GET /cheil_orgs" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get cheil_orgs_path
      response.status.should be(200)
    end
  end
end
