require 'spec_helper'

describe AdminUser do
  describe "duplicate name" do
    it "colud not save" do
      u = {:name=>'mark',:password=>'pass'}
      AdminUser.create(u)
      AdminUser.new(u).save.should be_false
    end
  end
end
