class DropBriefVendors < ActiveRecord::Migration
  def up
    drop_table :brief_vendors
  end

  def down
    create_table :brief_vendors do |t|
      t.integer :brief_id
      t.integer :org_id
      t.string :approved,:limit=>1,:default=>'n'

      t.timestamps
    end
  end
end
