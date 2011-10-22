require 'spec_helper'

describe Brief do
  #pending "add some examples to (or delete) #{__FILE__}"
  before do
    b = Brief.create(:name=>'brief1')
    b.items.create(:name => 'design1',:kind => 'design')
    b.items.create(:name => 'product1',:kind => 'product')
    b.items.create(:name => 'product2',:kind => 'product')
  end

  describe '#designs' do
    it 'should return one design' do
      b = Brief.find_by_name('brief1')
      b.designs.length.should == 1
      b.designs[0].destroy
      b.designs.should eq([])
    end
  end
  describe '#product' do
    it 'should return one product' do
      b = Brief.find_by_name('brief1')
      b.products.length.should == 2
    end
  end

  describe '#comments' do
    it 'should has no comment' do
      b = Brief.find_by_name('brief1')
      b.comments.should  eq([])
    end

    it 'should has 2 comments' do
      b = Brief.find_by_name('brief1')
      b.comments.create([{:content=>'c1'},{:content=>'c2'}])
      b.should have(2).comments
    end

    it 'should order by id' do
      b = Brief.find_by_name('brief1')
      b.comments.create([{:content=>'c1'},{:content=>'c2'}])
      ids = b.comments.collect{|e| e.id }
      (ids[0] < ids[1]).should be_true 
    end
  end
end
