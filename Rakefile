require 'active_record'
require "feedjira"

task :default => :migrate

desc "Migrate database"
task :migrate => :environment do
  ActiveRecord::Migrator.migrate('db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil )
end

task :environment do
  ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || 'sqlite3://localhost/entry.db')

  class Entry < ActiveRecord::Base
  end

  feed = Feedjira::Feed.fetch_and_parse(FEED_URL)
  feed.entries.each do |entry|
    entry = Entry.new(:tag => entry.id,
              :published => entry.published,
              :updated => entry.updated)
    entry.save
  end

end
