require 'spec_helper'

describe "orgs/new.html.erb" do
  before(:each) do
    assign(:org, stub_model(Org,
      :name => "MyString",
      :role => "MyString"
    ).as_new_record)
  end

  it "renders new org form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => orgs_path, :method => "post" do
      assert_select "input#org_name", :name => "org[name]"
      assert_select "input#org_role", :name => "org[role]"
    end
  end
end
