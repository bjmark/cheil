class Item < ActiveRecord::Base
  belongs_to :brief
  belongs_to :brief_vendor
  belongs_to :parent_item,:class_name=>'Item',:foreign_key=>'parent_id'
  has_many :child_items,:class_name=>'Item',:foreign_key=>'parent_id'
end
