require 'spec_helper'

describe "briefs/index.html.erb" do
  before(:each) do
    assign(:briefs, [
      stub_model(Brief,
        :name => "Name",
        :user_id => 1,
        :org_id => 1
      ),
      stub_model(Brief,
        :name => "Name",
        :user_id => 1,
        :org_id => 1
      )
    ])
  end

  it "renders a list of briefs" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
