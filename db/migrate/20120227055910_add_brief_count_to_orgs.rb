class AddBriefCountToOrgs < ActiveRecord::Migration
  def change
    add_column :orgs,:brief_count,:integer,:default=>0
    add_column :orgs,:money_sum,:integer,:default=>0
  end
end
