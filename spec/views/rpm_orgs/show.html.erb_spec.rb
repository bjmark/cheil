require 'spec_helper'

describe "rpm_orgs/show.html.erb" do
  before(:each) do
    @rpm_org = assign(:rpm_org, stub_model(RpmOrg))
  end

  it "renders attributes in <p>" do
    render
  end
end
