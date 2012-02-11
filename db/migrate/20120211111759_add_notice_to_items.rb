class AddNoticeToItems < ActiveRecord::Migration
  def change
    add_column :items,:notice,:string
  end
end
