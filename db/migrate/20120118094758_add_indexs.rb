class AddIndexs < ActiveRecord::Migration
  def up
    add_index :attaches,:fk_id
    add_index :briefs,:rpm_id
    add_index :briefs,:cheil_id
    add_index :comments,:fk_id
    add_index :items,:fk_id
    add_index :payments,:solution_id
    add_index :solutions,:brief_id
    add_index :solutions,:org_id
  end

  def down
    remove_index :attaches,:fk_id
    remove_index :briefs,:rpm_id
    remove_index :briefs,:cheil_id
    remove_index :comments,:fk_id
    remove_index :items,:fk_id
    remove_index :payments,:solution_id
    remove_index :solutions,:brief_id
    remove_index :solutions,:org_id
  end
end
