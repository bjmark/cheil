class AddNoticeToAttaches < ActiveRecord::Migration
  def change
    add_column :attaches,:notice,:string
  end
end
