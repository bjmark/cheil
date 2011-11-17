class AddNoteToItems < ActiveRecord::Migration
  def change
    add_column :items,:note,:string
    remove_column :items,:material
  end
end
