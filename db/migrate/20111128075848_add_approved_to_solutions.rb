class AddApprovedToSolutions < ActiveRecord::Migration
  def change
    add_column :solutions,:is_approved,:string,:limit=>1,:default=>'n'
    add_column :solutions,:approved_at,:datetime
  end
end
