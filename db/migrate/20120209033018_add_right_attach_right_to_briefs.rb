class AddRightAttachRightToBriefs < ActiveRecord::Migration
  def change
    add_column :briefs,:self_right,:string
    add_column :briefs,:attach_right,:string
    add_column :briefs,:item_right,:string
    add_column :briefs,:comment_right,:string
  end
end
