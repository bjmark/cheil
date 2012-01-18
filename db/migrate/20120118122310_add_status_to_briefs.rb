class AddStatusToBriefs < ActiveRecord::Migration
  def change
    add_column :briefs,:status,:integer
  end
end
