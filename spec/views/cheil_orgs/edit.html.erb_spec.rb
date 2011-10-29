require 'spec_helper'

describe "cheil_orgs/edit.html.erb" do
  before(:each) do
    @cheil_org = assign(:cheil_org, stub_model(CheilOrg))
  end

  it "renders the edit cheil_org form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => cheil_orgs_path(@cheil_org), :method => "post" do
    end
  end
end
