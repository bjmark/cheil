require 'spec_helper'

describe "cheil_orgs/index.html.erb" do
  before(:each) do
    assign(:cheil_orgs, [
      stub_model(CheilOrg),
      stub_model(CheilOrg)
    ])
  end

  it "renders a list of cheil_orgs" do
    render
  end
end
