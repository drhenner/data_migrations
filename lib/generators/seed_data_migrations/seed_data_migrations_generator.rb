require 'rails/generators/base'

class SeedDataMigrationsGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("../templates", __FILE__)

  def generate_seed_data_migrations
    #copy_file "seed_migrations_migration.rb", "db/seeds/#{file_name}.rb"
    create_file "db/seeds/#{next_migration_number}_#{file_name}.rb", <<-FILE
class #{file_name.camelize} < ActiveRecord::DataMigration
  def up
    #
  end
end

FILE
  end
  private
  def next_migration_number
    Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
  end
end
