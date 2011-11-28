require 'spec_helper'

describe "payers/edit.html.erb" do
  before(:each) do
    @payer = assign(:payer, stub_model(Payer))
  end

  it "renders the edit payer form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => payers_path(@payer), :method => "post" do
    end
  end
end
