class CreateAttaches < ActiveRecord::Migration
  def change
    create_table :attaches do |t|
      t.string  :type
      t.integer :fk_id
      t.integer :user_id

      t.string :attach_file_name
      t.string :attach_content_type
      t.integer :attach_file_size
      t.datetime :attach_updated_at

      t.timestamps
    end
  end
end
