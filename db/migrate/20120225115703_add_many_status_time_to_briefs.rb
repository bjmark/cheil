class AddManyStatusTimeToBriefs < ActiveRecord::Migration
  def change
    add_column :briefs,:status_10,:datetime
    add_column :briefs,:status_20,:datetime
    add_column :briefs,:status_30,:datetime
    add_column :briefs,:status_40,:datetime
    add_column :briefs,:status_50,:datetime
    add_column :briefs,:status_60,:datetime
  end
end
