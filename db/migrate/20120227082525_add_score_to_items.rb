class AddScoreToItems < ActiveRecord::Migration
  def change
    add_column :items,:score,:integer
  end
end
