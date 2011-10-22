require 'spec_helper'

describe "orgs/show.html.erb" do
  before(:each) do
    @org = assign(:org, stub_model(Org,
      :name => "Name",
      :role => "Role"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Role/)
  end
end
