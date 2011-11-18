class AddCheckedToAttaches < ActiveRecord::Migration
  def change
    add_column :attaches,:checked,:string,:limit=>1,:default=>'n'
  end
end
