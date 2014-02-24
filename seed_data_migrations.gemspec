$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "seed_data_migrations/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "seed_data_migrations"
  s.version     = SeedDataMigrations::VERSION
  s.authors     = ["David Henner"]
  s.email       = ["drhenner@gmail.com"]
  s.homepage    = "http://backops.co"
  s.summary     = "If you are migration seed data and only what the migration to run once it is best to log that the migration has already run."
  s.description = "If you are migration seed data and only what the migration to run once it is best to log that the migration has already run.  This separates data migrations from schema migrations."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "> 3.2.12"

  s.add_development_dependency "sqlite3"
end
