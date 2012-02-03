class CreateLogins < ActiveRecord::Migration
  def change
    create_table :logins do |t|
      t.string :name
      t.string :ip
      t.datetime :login_time
      t.datetime :logout_time
      t.column :is_logout,:string,:limit=>1,:default=>'n'
      t.timestamps
    end
  end
end
