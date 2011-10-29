require 'spec_helper'

describe "rpm_orgs/edit.html.erb" do
  before(:each) do
    @rpm_org = assign(:rpm_org, stub_model(RpmOrg))
  end

  it "renders the edit rpm_org form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => rpm_orgs_path(@rpm_org), :method => "post" do
    end
  end
end
