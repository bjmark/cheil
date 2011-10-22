class RenameVendorIdInItems < ActiveRecord::Migration
  def up
    change_table :items do |t|
      t.rename(:vendor_id,:brief_vendor_id)
    end
  end

  def down
    change_talbe :items do |t|
      t.rename(:brief_vendor_id,:vendor_id)
    end
  end
end
