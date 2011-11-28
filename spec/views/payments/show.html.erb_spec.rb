require 'spec_helper'

describe "payments/show.html.erb" do
  before(:each) do
    @payment = assign(:payment, stub_model(Payment,
      :solution_id => 1,
      :payer_id => 1,
      :org_id => 1,
      :amount => "Amount",
      :note => "Note"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Amount/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Note/)
  end
end
