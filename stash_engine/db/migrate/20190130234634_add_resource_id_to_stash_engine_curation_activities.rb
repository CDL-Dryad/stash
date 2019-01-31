class AddResourceIdToStashEngineCurationActivities < ActiveRecord::Migration
  def change
    add_column :stash_engine_curation_activities, :resource_id, :integer, after: :identifier_id
  end
end
