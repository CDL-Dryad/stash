# This migration comes from stash_datacite (originally 20161207193328)
class MakeResourceTypeGeneral < ActiveRecord::Migration
  def self.up
    rename_column :dcs_resource_types, :resource_type, :resource_type_general
    add_column :dcs_resource_types, :resource_type, :text, :after => :resource_type_general
    StashDatacite::ResourceType.update_all("resource_type=resource_type_general")
  end

  def self.down
    remove_column :dcs_resource_types, :resource_type
    rename_column :dcs_resource_types, :resource_type_general, :resource_type
  end
end
