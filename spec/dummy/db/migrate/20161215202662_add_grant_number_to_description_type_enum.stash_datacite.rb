# This migration comes from stash_datacite (originally 20160715195538)
class AddGrantNumberToDescriptionTypeEnum < ActiveRecord::Migration
  def change
    change_table :dcs_descriptions do |t|
      t.change :description_type, "ENUM('abstract', 'methods', 'seriesinformation', 'tableofcontents', 'other',
          'usage_notes', 'grant_number') DEFAULT NULL"
    end
  end
end
