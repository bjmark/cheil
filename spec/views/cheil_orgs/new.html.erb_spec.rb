require 'spec_helper'

describe "cheil_orgs/new.html.erb" do
  before(:each) do
    assign(:cheil_org, stub_model(CheilOrg).as_new_record)
  end

  it "renders new cheil_org form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => cheil_orgs_path, :method => "post" do
    end
  end
end
