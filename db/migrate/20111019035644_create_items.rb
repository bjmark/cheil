class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.integer :brief_id
      t.string :name
      t.string :quantity
      t.string :price
      t.string :kind
      t.integer :parent_id,:default=>0
      t.integer :vendor_id
      t.string :checked,:limit => 1,:default=>'n'

      t.timestamps
    end
  end
end
