class CreateSolutions < ActiveRecord::Migration
  def change
    create_table :solutions do |t|
      t.integer :brief_id
      t.integer :org_id
      t.string :type
      t.string :is_sent
      t.datetime :sent_time

      t.timestamps
    end
  end
end
