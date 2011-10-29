require 'spec_helper'

describe "rpm_orgs/new.html.erb" do
  before(:each) do
    assign(:rpm_org, stub_model(RpmOrg).as_new_record)
  end

  it "renders new rpm_org form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => rpm_orgs_path, :method => "post" do
    end
  end
end
