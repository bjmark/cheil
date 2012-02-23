class AddManyTotalUpToSolutions < ActiveRecord::Migration
  def change
    add_column :solutions,:design_sum,:integer,:default => 0
    add_column :solutions,:product_sum,:integer,:default => 0
    add_column :solutions,:tran_sum,:integer,:default => 0
    add_column :solutions,:other_sum,:integer,:default => 0

    add_column :solutions,:design_tax_sum,:integer,:default => 0
    add_column :solutions,:product_tax_sum,:integer,:default => 0
    add_column :solutions,:tran_tax_sum,:integer,:default => 0
    add_column :solutions,:other_tax_sum,:integer,:default => 0

    add_column :solutions,:design_and_tax_sum,:integer,:default => 0
    add_column :solutions,:product_and_sum,:integer,:default => 0
    add_column :solutions,:tran_and_tax_sum,:integer,:default => 0
    add_column :solutions,:other_and_tax_sum,:integer,:default => 0

    add_column :solutions,:all_sum,:integer,:default => 0
    add_column :solutions,:all_tax_sum,:integer,:default => 0
    add_column :solutions,:all_and_tax_sum,:integer,:default => 0

    add_column :solutions,:design_c_sum,:integer,:default => 0
    add_column :solutions,:product_c_sum,:integer,:default => 0
    add_column :solutions,:tran_c_sum,:integer,:default => 0
    add_column :solutions,:other_c_sum,:integer,:default => 0

    add_column :solutions,:design_c_tax_sum,:integer,:default => 0
    add_column :solutions,:product_c_tax_sum,:integer,:default => 0
    add_column :solutions,:tran_c_tax_sum,:integer,:default => 0
    add_column :solutions,:other_c_tax_sum,:integer,:default => 0

    add_column :solutions,:design_c_and_tax_sum,:integer,:default => 0
    add_column :solutions,:product_c_and_tax_sum,:integer,:default => 0
    add_column :solutions,:tran_c_and_tax_sum,:integer,:default => 0
    add_column :solutions,:other_c_and_tax_sum,:integer,:default => 0

    add_column :solutions,:all_c_sum,:integer,:default => 0
    add_column :solutions,:all_c_tax_sum,:integer,:default => 0
    add_column :solutions,:all_c_and_tax_sum,:integer,:default => 0
  end
end
