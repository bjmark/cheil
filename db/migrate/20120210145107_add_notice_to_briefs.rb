class AddNoticeToBriefs < ActiveRecord::Migration
  def change
    add_column :briefs,:notice,:string
  end
end
