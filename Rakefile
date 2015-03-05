require 'active_record'
require "feedjira"

namespace :db do

  ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || 'sqlite3://localhost/entry.db')

  ActiveRecord::Base.logger = Logger.new(STDOUT)

  desc "Migrate database"
  task :migrate do
    ActiveRecord::Migrator.migrate('db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil )
  end

end
