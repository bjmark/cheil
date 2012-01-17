class AddReadByToSolutions < ActiveRecord::Migration
  def change
    add_column :solutions,:read_by,:string
  end
end
