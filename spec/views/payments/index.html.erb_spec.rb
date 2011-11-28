require 'spec_helper'

describe "payments/index.html.erb" do
  before(:each) do
    assign(:payments, [
      stub_model(Payment,
        :solution_id => 1,
        :payer_id => 1,
        :org_id => 1,
        :amount => "Amount",
        :note => "Note"
      ),
      stub_model(Payment,
        :solution_id => 1,
        :payer_id => 1,
        :org_id => 1,
        :amount => "Amount",
        :note => "Note"
      )
    ])
  end

  it "renders a list of payments" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Amount".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Note".to_s, :count => 2
  end
end
