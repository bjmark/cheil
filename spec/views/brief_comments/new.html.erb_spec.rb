require 'spec_helper'

describe "brief_comments/new.html.erb" do
  before(:each) do
    assign(:brief_comment, stub_model(BriefComment,
      :content => "MyString",
      :brief_id => 1,
      :user_id => 1
    ).as_new_record)
  end

  it "renders new brief_comment form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => brief_comments_path, :method => "post" do
      assert_select "input#brief_comment_content", :name => "brief_comment[content]"
      assert_select "input#brief_comment_brief_id", :name => "brief_comment[brief_id]"
      assert_select "input#brief_comment_user_id", :name => "brief_comment[user_id]"
    end
  end
end
