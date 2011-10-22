class CreateBriefComments < ActiveRecord::Migration
  def change
    create_table :brief_comments do |t|
      t.string :content
      t.integer :brief_id
      t.integer :user_id

      t.timestamps
    end
  end
end
