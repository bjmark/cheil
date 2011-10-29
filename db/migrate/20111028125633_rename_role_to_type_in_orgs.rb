class RenameRoleToTypeInOrgs < ActiveRecord::Migration
  def up
    rename_column :orgs,:role,:type
  end

  def down
    rename_column :orgs,:type,:role
  end
end
