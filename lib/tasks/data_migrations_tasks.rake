# desc "Explaining what the task does"
# task :data_migrations do
#   # Task goes here
# end


db_namespace = namespace :db do

  desc "Migrate the seed data (options: VERSION=x, VERBOSE=false, SCOPE=blog)."
  task :migrate_data => [:environment, :load_config] do
    ActiveRecord::DataMigration.verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true
    ActiveRecord::DataMigrator.migrate(ActiveRecord::DataMigrator.migrations_paths, ENV["VERSION"] ? ENV["VERSION"].to_i : nil) do |migration|
      ENV["SCOPE"].blank? || (ENV["SCOPE"] == migration.scope)
    end
  end

  # rake db:migrate_data --trace
  desc "migrate seed data in /db/seeds/*"
  namespace :migrate_data do

    # desc 'Resets your database using your migrations for the current environment'
    task :reset => ['db:drop', 'db:create', 'db:migrate']

    # desc 'Runs the "up" for a given migration VERSION.'
    task :up => [:environment, :load_config] do
      version = ENV['VERSION'] ? ENV['VERSION'].to_i : nil
      raise 'VERSION is required' unless version
      ActiveRecord::DataMigrator.run(:up, ActiveRecord::DataMigrator.migrations_paths, version)
      db_namespace['_dump'].invoke
    end

    # desc 'creates a new data migration.'
    #task :new => [:environment, :load_config] do
    #  version = ENV['VERSION'] ? ENV['VERSION'].to_i : nil
    #  raise 'VERSION is required' unless version
    #end

    desc 'Display status of migrations'
    task :status => [:environment, :load_config] do
      unless ActiveRecord::Base.connection.table_exists?(ActiveRecord::DataMigrator.schema_data_migrations_table_name)
        puts 'Schema migrations table does not exist yet.'
        next  # means "return" for rake task
      end
      db_list = ActiveRecord::Base.connection.select_values("SELECT version FROM #{ActiveRecord::DataMigrator.schema_data_migrations_table_name}")
      db_list.map! { |version| "%.3d" % version }
      file_list = []
      ActiveRecord::DataMigrator.migrations_paths.each do |path|
        Dir.foreach(path) do |file|
          # match "20091231235959_some_name.rb" and "001_some_name.rb" pattern
          if match_data = /^(\d{3,})_(.+)\.rb$/.match(file)
            status = db_list.delete(match_data[1]) ? 'up' : 'down'
            file_list << [status, match_data[1], match_data[2].humanize]
          end
        end
      end
      db_list.map! do |version|
        ['up', version, '********** NO FILE **********']
      end
      # output
      puts "\ndatabase: #{ActiveRecord::Base.connection_config[:database]}\n\n"
      puts "#{'Status'.center(8)}  #{'Migration ID'.ljust(14)}  Migration Name"
      puts "-" * 50
      (db_list + file_list).sort_by {|migration| migration[1]}.each do |migration|
        puts "#{migration[0].center(8)}  #{migration[1].ljust(14)}  #{migration[2]}"
      end
      puts
    end
  end
end
