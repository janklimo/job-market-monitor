class AddSetToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :set_index, :float
  end
end
