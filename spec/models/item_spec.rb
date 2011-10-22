require 'spec_helper'

describe Item do
  #pending "add some examples to (or delete) #{__FILE__}"
  describe 'belongs_to parent_item' do
    it "should make a parent_item" do
      parent = Item.create
      child = Item.create{|r| r.parent_id = parent.id}

      child.parent_item.should eq(parent)
      parent.should have(1).child_items
    end
  end
end
