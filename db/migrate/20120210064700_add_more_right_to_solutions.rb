class AddMoreRightToSolutions < ActiveRecord::Migration
  def change
    add_column :solutions,:attach_right,:string
    add_column :solutions,:item_right,:string
    add_column :solutions,:comment_right,:string
  end
end
