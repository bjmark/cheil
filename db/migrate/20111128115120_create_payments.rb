class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :solution_id
      t.integer :payer_id
      t.integer :org_id
      t.string :amount
      t.date :pay_date
      t.string :note

      t.timestamps
    end
  end
end
