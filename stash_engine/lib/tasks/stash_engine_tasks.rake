require_relative 'identifier_rake_functions'

# rubocop:disable Metrics/BlockLength
namespace :identifiers do
  desc 'Give resources missing a stash_engine_identifier one (run from main app, not engine)'
  task fix_missing: :environment do # loads rails environment
    IdentifierRakeFunctions.update_identifiers
  end

  desc "Update identifiers latest resource if they don't have one"
  task add_latest_resource: :environment do
    StashEngine::Identifier.where(latest_resource_id: nil).each do |se_identifier|
      puts "Updating identifier #{se_identifier.id}: #{se_identifier}"
      res = StashEngine::Resource.where(identifier_id: se_identifier.id).order(created_at: :desc).first
      if res.nil?
        se_identifier.destroy! # useless orphan identifier with no contents which should be deleted
      else
        se_identifier.update!(latest_resource_id: res.id)
      end
    end
  end

  desc 'Add searchable field contents for any identifiers missing it'
  task add_search: :environment do
    StashEngine::Identifier.where(search_words: nil).each do |se_identifier|
      puts "Updating identifier #{se_identifier} for search"
      se_identifier.update_search_words!
    end
  end

  desc 'update dataset license from tenant settings'
  task write_licenses: :environment do
    StashEngine::Identifier.all.each do |se_identifier|
      license = se_identifier&.latest_resource&.tenant&.default_license
      next if license.blank? || license == se_identifier.license_id
      puts "Updating license to #{license} for #{se_identifier}"
      se_identifier.update(license_id: license)
    end
  end

  desc "remove orphaned curation activities"
  task remove_orphaned_curation_activity: :environment do
    StashEngine::CurationActivity.all.each do |ca|
      if StashEngine::Identifier.where(id: ca.identifier_id).empty?
        p "Removing orphaned curation_activity: #{ca.inspect}"
        ca.destroy
      end
    end
  end

  desc "update resource_id on curation_activities"
  task add_resource_ids_to_curation_activities: :environment do
    # Set the resource_id on all existing curation_activities
    StashEngine::CurationActivity.all.each do |ca|
      i = StashEngine::Identifier.find(ca.identifier_id)
      p "Updating CurationActivity #{ca.id} with resource_id=#{i.latest_resource&.id}"
      ca.update(resource_id: i.latest_resource&.id) unless ca.resource_id.present?
    end
    # Add a record to curation_activities for each Resource that does not have one
    StashEngine::Identifier.includes(resources: :curation_activities).all.each do |i|
      i.resources.each do |r|
        if r.curation_activities.empty?
          status = r.submitted? ? 'Submitted' : 'Unsubmitted'
          p "Initializing CurationActivity for Resource #{r.id} - #{status}"

          StashEngine::CurationActivity.create(
            resource_id: r.id,
            identifier_id: i.id,
            user_id: r.user_id,
            note: 'Initialized',
            status: status
          )
        end
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
