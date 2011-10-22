require 'spec_helper'

describe "orgs/edit.html.erb" do
  before(:each) do
    @org = assign(:org, stub_model(Org,
      :name => "MyString",
      :role => "MyString"
    ))
  end

  it "renders the edit org form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => orgs_path(@org), :method => "post" do
      assert_select "input#org_name", :name => "org[name]"
      assert_select "input#org_role", :name => "org[role]"
    end
  end
end
