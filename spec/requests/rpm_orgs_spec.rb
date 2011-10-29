require 'spec_helper'

describe "RpmOrgs" do
  describe "GET /rpm_orgs" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get rpm_orgs_path
      response.status.should be(200)
    end
  end
end
