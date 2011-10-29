require 'spec_helper'

describe "vendor_orgs/index.html.erb" do
  before(:each) do
    assign(:vendor_orgs, [
      stub_model(VendorOrg),
      stub_model(VendorOrg)
    ])
  end

  it "renders a list of vendor_orgs" do
    render
  end
end
