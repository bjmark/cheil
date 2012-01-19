class AddFinishAtToSolutions < ActiveRecord::Migration
  def change
    add_column :solutions,:finish_at,:datetime
  end
end
