class AddSelfRightToSolutions < ActiveRecord::Migration
  def change
    add_column :solutions,:self_right,:string
  end
end
