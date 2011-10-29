class AddRpmOrgIdToOrgs < ActiveRecord::Migration
  def change
    add_column :orgs, :rpm_org_id, :integer
  end
end
