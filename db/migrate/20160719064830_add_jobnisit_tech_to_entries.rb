class AddJobnisitTechToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :job_nisit_tech, :integer
  end
end
