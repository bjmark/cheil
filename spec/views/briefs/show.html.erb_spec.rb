require 'spec_helper'

describe "briefs/show.html.erb" do
  before(:each) do
    @brief = assign(:brief, stub_model(Brief,
      :name => "Name",
      :user_id => 1,
      :org_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
