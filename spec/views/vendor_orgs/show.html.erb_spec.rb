require 'spec_helper'

describe "vendor_orgs/show.html.erb" do
  before(:each) do
    @vendor_org = assign(:vendor_org, stub_model(VendorOrg))
  end

  it "renders attributes in <p>" do
    render
  end
end
