class RemoveAdminSites < ActiveRecord::Migration
  def self.up
    drop_table :admin_sites
  end

  def self.down
    # no down - my bad - should not have been committed (scaffold issue)
  end
end
