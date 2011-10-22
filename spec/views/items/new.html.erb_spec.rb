require 'spec_helper'

describe "items/new.html.erb" do
  before(:each) do
    assign(:item, stub_model(Item,
      :brief_id => 1,
      :quantity => "MyString",
      :price => "MyString",
      :kind => "MyString",
      :parent_id => 1,
      :vendor_id => 1,
      :checked => "MyString"
    ).as_new_record)
  end

  it "renders new item form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => items_path, :method => "post" do
      assert_select "input#item_brief_id", :name => "item[brief_id]"
      assert_select "input#item_quantity", :name => "item[quantity]"
      assert_select "input#item_price", :name => "item[price]"
      assert_select "input#item_kind", :name => "item[kind]"
      assert_select "input#item_parent_id", :name => "item[parent_id]"
      assert_select "input#item_vendor_id", :name => "item[vendor_id]"
      assert_select "input#item_checked", :name => "item[checked]"
    end
  end
end
