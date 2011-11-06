require 'spec_helper'

describe "attaches/edit.html.erb" do
  before(:each) do
    @attach = assign(:attach, stub_model(Attach,
      :fk_id => ""
    ))
  end

  it "renders the edit attach form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => attaches_path(@attach), :method => "post" do
      assert_select "input#attach_fk_id", :name => "attach[fk_id]"
    end
  end
end
