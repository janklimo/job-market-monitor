class AddJobNisitTotalToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :job_nisit_total, :integer
  end
end
