class ChangeContentType < ActiveRecord::Migration
  def up
    remove_column :comments,:content
    add_column :comments,:content,:text
  end

  def down
    remove_column :comments,:content
    add_column :comments,:content,:string
  end
end
