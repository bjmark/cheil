class AddReadByToAttaches < ActiveRecord::Migration
  def change
    add_column :attaches,:read_by,:string
  end
end
