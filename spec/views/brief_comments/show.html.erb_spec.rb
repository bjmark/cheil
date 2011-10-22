require 'spec_helper'

describe "brief_comments/show.html.erb" do
  before(:each) do
    @brief_comment = assign(:brief_comment, stub_model(BriefComment,
      :content => "Content",
      :brief_id => 1,
      :user_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Content/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
