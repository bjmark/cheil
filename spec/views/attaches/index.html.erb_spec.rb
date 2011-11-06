require 'spec_helper'

describe "attaches/index.html.erb" do
  before(:each) do
    assign(:attaches, [
      stub_model(Attach,
        :fk_id => ""
      ),
      stub_model(Attach,
        :fk_id => ""
      )
    ])
  end

  it "renders a list of attaches" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end
