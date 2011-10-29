require 'spec_helper'

describe "vendor_orgs/new.html.erb" do
  before(:each) do
    assign(:vendor_org, stub_model(VendorOrg).as_new_record)
  end

  it "renders new vendor_org form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => vendor_orgs_path, :method => "post" do
    end
  end
end
