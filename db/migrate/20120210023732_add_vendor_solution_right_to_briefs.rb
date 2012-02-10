class AddVendorSolutionRightToBriefs < ActiveRecord::Migration
  def change
    add_column :briefs,:vendor_solution_right,:string
  end
end
