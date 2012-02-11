class AddSelfRightToComments < ActiveRecord::Migration
  def change
    add_column :comments,:self_right,:string
  end
end
