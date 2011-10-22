require 'spec_helper'

describe "briefs/edit.html.erb" do
  before(:each) do
    @brief = assign(:brief, stub_model(Brief,
      :name => "MyString",
      :user_id => 1,
      :org_id => 1
    ))
  end

  it "renders the edit brief form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => briefs_path(@brief), :method => "post" do
      assert_select "input#brief_name", :name => "brief[name]"
      assert_select "input#brief_user_id", :name => "brief[user_id]"
      assert_select "input#brief_org_id", :name => "brief[org_id]"
    end
  end
end
