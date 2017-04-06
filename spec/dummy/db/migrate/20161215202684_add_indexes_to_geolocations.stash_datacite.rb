# This migration comes from stash_datacite (originally 20160919232927)
class AddIndexesToGeolocations < ActiveRecord::Migration
  def change
    add_index(:dcs_geo_locations, :place_id)
    add_index(:dcs_geo_locations, :point_id)
    add_index(:dcs_geo_locations, :box_id)
  end
end
