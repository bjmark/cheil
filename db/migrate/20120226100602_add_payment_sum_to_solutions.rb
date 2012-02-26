class AddPaymentSumToSolutions < ActiveRecord::Migration
  def change
    add_column :solutions,:payment_sum,:integer,:default=>0
    add_column :solutions,:balance,:integer,:default=>0
  end
end
