require 'active_record'
require "feedjira"
require 'parse-ruby-client'
require 'eventmachine'

Parse.init :application_id => ENV['PARSE_APP_ID'],
           :api_key        => ENV['PARSE_API_KEY']

=begin
ActiveRecord::Base.establish_connection(
  "adapter" => "sqlite3",
  "database" => "./entry.db"
)
=end

ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || 'sqlite3://localhost/entry.db')

class Entry < ActiveRecord::Base
end


def push_notification(url) # must String
  data = { :alert => "Push from nogifeed observer : " + url.to_s, :url => url.to_s }
  push = Parse::Push.new(data)
  push.where = { :deviceType => "android" }
  p push.save
end

def push_json(url, title, author)
  data = { :action=> "android.shts.jp.nogifeed.UPDATE_STATUS",
           :_url => url.to_s,
           :_title => title.to_s,
           :_author => author.to_s }
  push = Parse::Push.new(data)
  push.where = { :deviceType => "android" }
  p push.save
end

FEED_URL="http://blog.nogizaka46.com/atom.xml"

def init
  feed = Feedjira::Feed.fetch_and_parse(FEED_URL)
  feed.entries.each do |entry|
    entry = Entry.new(:tag => entry.id,
              :published => entry.published,
              :updated => entry.updated)
    entry.save
  end
end

EM.run do

  if Entry.count == 0
    p "database initialize"
    init
  end

  EM::PeriodicTimer.new(60) do
    p "fetch feed"
    feed = Feedjira::Feed.fetch_and_parse(FEED_URL)
    feed.entries.each do |entry|
      Entry.where(:tag => entry.id).first_or_create do |e|
        p "feed updated"
        #add new record
        e.tag = entry.id
        e.published = entry.published
        e.updated = entry.updated
        #push notifiction message
        push_json(entry.url, entry.title, entry.author)
      end
    end
  end

end
