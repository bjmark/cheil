require 'spec_helper'

describe "payments/new.html.erb" do
  before(:each) do
    assign(:payment, stub_model(Payment,
      :solution_id => 1,
      :payer_id => 1,
      :org_id => 1,
      :amount => "MyString",
      :note => "MyString"
    ).as_new_record)
  end

  it "renders new payment form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => payments_path, :method => "post" do
      assert_select "input#payment_solution_id", :name => "payment[solution_id]"
      assert_select "input#payment_payer_id", :name => "payment[payer_id]"
      assert_select "input#payment_org_id", :name => "payment[org_id]"
      assert_select "input#payment_amount", :name => "payment[amount]"
      assert_select "input#payment_note", :name => "payment[note]"
    end
  end
end
