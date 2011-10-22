require 'spec_helper'

describe "admin_users/index.html.erb" do
  before(:each) do
    assign(:admin_users, [
      stub_model(AdminUser,
        :name => "Name",
        :hashed_password => "Hashed Password",
        :salt => "Salt"
      ),
      stub_model(AdminUser,
        :name => "Name",
        :hashed_password => "Hashed Password",
        :salt => "Salt"
      )
    ])
  end

  it "renders a list of admin_users" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Hashed Password".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Salt".to_s, :count => 2
  end
end
