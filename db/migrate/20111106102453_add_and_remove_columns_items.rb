class AddAndRemoveColumnsItems < ActiveRecord::Migration
  def up
    remove_column :items,:brief_id
    remove_column :items,:brief_vendor_id
    add_column :items,:type,:string
    add_column :items,:fk_id,:integer
    add_column :items,:material,:string
  end

  def down
    add_column :items,:brief_id,:integer
    add_column :items,:brief_vendor_id,:integer
    remove_column :items,:type
    remove_column :items,:fk_id
    remove_column :items,:material
  end
end
