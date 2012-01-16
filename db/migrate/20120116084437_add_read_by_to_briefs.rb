class AddReadByToBriefs < ActiveRecord::Migration
  def change
    add_column :briefs,:read_by,:string
  end
end
