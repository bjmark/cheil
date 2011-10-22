class CreateBriefVendors < ActiveRecord::Migration
  def change
    create_table :brief_vendors do |t|
      t.integer :brief_id
      t.integer :org_id
      t.string :approved,:limit=>1,:default=>'n'

      t.timestamps
    end
  end
end
