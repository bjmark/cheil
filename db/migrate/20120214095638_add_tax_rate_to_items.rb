class AddTaxRateToItems < ActiveRecord::Migration
  def change
    add_column :items,:tax_rate,:string
    add_column :items,:tax,:string
    add_column :items,:total_up,:string
    add_column :items,:total_up_tax,:string
  end
end
