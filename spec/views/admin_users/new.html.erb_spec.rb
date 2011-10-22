require 'spec_helper'

describe "admin_users/new.html.erb" do
  before(:each) do
    assign(:admin_user, stub_model(AdminUser,
      :name => "MyString",
      :hashed_password => "MyString",
      :salt => "MyString"
    ).as_new_record)
  end

  it "renders new admin_user form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_users_path, :method => "post" do
      assert_select "input#admin_user_name", :name => "admin_user[name]"
      assert_select "input#admin_user_hashed_password", :name => "admin_user[hashed_password]"
      assert_select "input#admin_user_salt", :name => "admin_user[salt]"
    end
  end
end
