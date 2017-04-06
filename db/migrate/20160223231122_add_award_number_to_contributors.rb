class AddAwardNumberToContributors < ActiveRecord::Migration
  def up
    add_column :dcs_contributors, :award_number, :string
  end

  def down
    remove_column :dcs_contributors, :award_number
  end
end
