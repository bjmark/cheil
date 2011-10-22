require 'spec_helper'

describe "BriefVendors" do
  describe "GET /brief_vendors" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get brief_vendors_path
      response.status.should be(200)
    end
  end
end
