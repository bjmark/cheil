require 'spec_helper'

describe "payers/index.html.erb" do
  before(:each) do
    assign(:payers, [
      stub_model(Payer),
      stub_model(Payer)
    ])
  end

  it "renders a list of payers" do
    render
  end
end
