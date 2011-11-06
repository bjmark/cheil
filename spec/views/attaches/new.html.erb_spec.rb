require 'spec_helper'

describe "attaches/new.html.erb" do
  before(:each) do
    assign(:attach, stub_model(Attach,
      :fk_id => ""
    ).as_new_record)
  end

  it "renders new attach form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => attaches_path, :method => "post" do
      assert_select "input#attach_fk_id", :name => "attach[fk_id]"
    end
  end
end
