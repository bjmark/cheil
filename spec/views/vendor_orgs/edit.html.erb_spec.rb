require 'spec_helper'

describe "vendor_orgs/edit.html.erb" do
  before(:each) do
    @vendor_org = assign(:vendor_org, stub_model(VendorOrg))
  end

  it "renders the edit vendor_org form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => vendor_orgs_path(@vendor_org), :method => "post" do
    end
  end
end
