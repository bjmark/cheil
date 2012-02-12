class AddNoticeToSolutions < ActiveRecord::Migration
  def change
    add_column :solutions,:notice,:string
  end
end
