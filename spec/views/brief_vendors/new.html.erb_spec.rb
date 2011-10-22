require 'spec_helper'

describe "brief_vendors/new.html.erb" do
  before(:each) do
    assign(:brief_vendor, stub_model(BriefVendor,
      :brief_id => 1,
      :org_id => 1,
      :approved => "MyString"
    ).as_new_record)
  end

  it "renders new brief_vendor form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => brief_vendors_path, :method => "post" do
      assert_select "input#brief_vendor_brief_id", :name => "brief_vendor[brief_id]"
      assert_select "input#brief_vendor_org_id", :name => "brief_vendor[org_id]"
      assert_select "input#brief_vendor_approved", :name => "brief_vendor[approved]"
    end
  end
end
