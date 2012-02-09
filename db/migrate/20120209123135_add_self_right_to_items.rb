class AddSelfRightToItems < ActiveRecord::Migration
  def change
    add_column :items,:self_right,:string
  end
end
