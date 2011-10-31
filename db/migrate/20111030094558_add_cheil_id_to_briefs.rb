class AddCheilIdToBriefs < ActiveRecord::Migration
  def up
    add_column :briefs, :cheil_id, :integer ,:default=>0
    rename_column :briefs,:org_id,:rpm_id
    add_column :briefs,:req,:text
    add_column :briefs,:deadline,:date
    remove_column :briefs,:send_to_cheil
  end

  def down 
    remove_column :briefs, :cheil_id
    rename_column :briefs,:rpm_id,:org_id
    remove_column :briefs,:req
    remove_column :briefs,:deadline
    add_column :briefs,:send_to_cheil,:string,:limit=>1,:default=>'n'
  end

end
