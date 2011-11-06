require 'spec_helper'

describe "attaches/show.html.erb" do
  before(:each) do
    @attach = assign(:attach, stub_model(Attach,
      :fk_id => ""
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
  end
end
