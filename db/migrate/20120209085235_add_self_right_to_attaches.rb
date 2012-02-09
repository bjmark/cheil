class AddSelfRightToAttaches < ActiveRecord::Migration
  def change
    add_column :attaches,:self_right,:string
  end
end
