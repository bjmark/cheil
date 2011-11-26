class AddRateToSolutions < ActiveRecord::Migration
  def change
    add_column :solutions,:design_rate,:string,:default=>'0'
    add_column :solutions,:product_rate,:string,:default=>'0'
    add_column :solutions,:tran_rate,:string,:default=>'0'
    add_column :solutions,:other_rate,:string,:default=>'0'
  end
end
