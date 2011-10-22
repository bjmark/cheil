require 'spec_helper'

describe "admin_users/show.html.erb" do
  before(:each) do
    @admin_user = assign(:admin_user, stub_model(AdminUser,
      :name => "Name",
      :hashed_password => "Hashed Password",
      :salt => "Salt"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Hashed Password/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Salt/)
  end
end
