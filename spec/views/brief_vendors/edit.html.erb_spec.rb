require 'spec_helper'

describe "brief_vendors/edit.html.erb" do
  before(:each) do
    @brief_vendor = assign(:brief_vendor, stub_model(BriefVendor,
      :brief_id => 1,
      :org_id => 1,
      :approved => "MyString"
    ))
  end

  it "renders the edit brief_vendor form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => brief_vendors_path(@brief_vendor), :method => "post" do
      assert_select "input#brief_vendor_brief_id", :name => "brief_vendor[brief_id]"
      assert_select "input#brief_vendor_org_id", :name => "brief_vendor[org_id]"
      assert_select "input#brief_vendor_approved", :name => "brief_vendor[approved]"
    end
  end
end
