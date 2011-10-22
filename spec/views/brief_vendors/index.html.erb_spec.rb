require 'spec_helper'

describe "brief_vendors/index.html.erb" do
  before(:each) do
    assign(:brief_vendors, [
      stub_model(BriefVendor,
        :brief_id => 1,
        :org_id => 1,
        :approved => "Approved"
      ),
      stub_model(BriefVendor,
        :brief_id => 1,
        :org_id => 1,
        :approved => "Approved"
      )
    ])
  end

  it "renders a list of brief_vendors" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Approved".to_s, :count => 2
  end
end
