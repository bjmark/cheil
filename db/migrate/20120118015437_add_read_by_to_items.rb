class AddReadByToItems < ActiveRecord::Migration
  def change
    add_column :items,:read_by,:string
  end
end
