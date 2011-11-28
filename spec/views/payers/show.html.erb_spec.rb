require 'spec_helper'

describe "payers/show.html.erb" do
  before(:each) do
    @payer = assign(:payer, stub_model(Payer))
  end

  it "renders attributes in <p>" do
    render
  end
end
