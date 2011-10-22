require 'spec_helper'

describe "brief_comments/index.html.erb" do
  before(:each) do
    assign(:brief_comments, [
      stub_model(BriefComment,
        :content => "Content",
        :brief_id => 1,
        :user_id => 1
      ),
      stub_model(BriefComment,
        :content => "Content",
        :brief_id => 1,
        :user_id => 1
      )
    ])
  end

  it "renders a list of brief_comments" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Content".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
