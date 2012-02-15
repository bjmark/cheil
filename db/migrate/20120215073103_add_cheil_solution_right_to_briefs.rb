class AddCheilSolutionRightToBriefs < ActiveRecord::Migration
  def change
    add_column :briefs,:cheil_solution_right,:string
  end
end
