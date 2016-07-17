class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.integer :jobs_db_total
      t.integer :jobs_db_tech

      t.timestamps null: false
    end
  end
end
