require 'spec_helper'

describe "cheil_orgs/show.html.erb" do
  before(:each) do
    @cheil_org = assign(:cheil_org, stub_model(CheilOrg))
  end

  it "renders attributes in <p>" do
    render
  end
end
