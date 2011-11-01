class CreateBriefAttaches < ActiveRecord::Migration
  def change
    create_table :brief_attaches do |t|
      t.integer :brief_id
      t.string :attach_file_name
      t.string :attach_content_type
      t.integer :attach_file_size
      t.datetime :attach_updated_at

      t.timestamps
    end
  end
end
