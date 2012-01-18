class AddCancelToBriefs < ActiveRecord::Migration
  def change
    add_column :briefs,:cancel,:string,:limit=>1,:default=>'n'
  end
end
