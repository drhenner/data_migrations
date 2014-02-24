class AddSeedMigrationsTable < ActiveRecord::Migration
  def up
    create_table :seed_migrations do |t|
      t.string :version, null: false
    end
  end

  def down
    drop_table :seed_migrations
  end
end
