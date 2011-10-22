require 'spec_helper'

describe "brief_vendors/show.html.erb" do
  before(:each) do
    @brief_vendor = assign(:brief_vendor, stub_model(BriefVendor,
      :brief_id => 1,
      :org_id => 1,
      :approved => "Approved"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Approved/)
  end
end
