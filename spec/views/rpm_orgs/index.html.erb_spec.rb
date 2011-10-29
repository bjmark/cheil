require 'spec_helper'

describe "rpm_orgs/index.html.erb" do
  before(:each) do
    assign(:rpm_orgs, [
      stub_model(RpmOrg),
      stub_model(RpmOrg)
    ])
  end

  it "renders a list of rpm_orgs" do
    render
  end
end
