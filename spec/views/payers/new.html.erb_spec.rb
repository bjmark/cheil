require 'spec_helper'

describe "payers/new.html.erb" do
  before(:each) do
    assign(:payer, stub_model(Payer).as_new_record)
  end

  it "renders new payer form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => payers_path, :method => "post" do
    end
  end
end
