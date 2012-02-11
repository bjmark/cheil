class AddNoticeToComments < ActiveRecord::Migration
  def change
    add_column :comments,:notice,:string
  end
end
