require "pry"
require_relative "db/setup"
require './lib/all'

def week
  week_number = (ENV['week'] ||= "0").to_i
  value = Time.at (week_number * 7).days.ago
end

class String
  def snake_case
    self.gsub(/::/, '/').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr("-", "_").
      downcase
  end
end

desc "Run migrations"
namespace :db do
  task :migrate do
    version = ENV["VERSION"] ? ENV["VERSION"].to_i : nil
    ActiveRecord::Migrator.migrate('db/migrate', version)
  end
end

desc "Generate migration"
namespace :generate do
  task :migration do |name|
    _, name = ARGV
    unless name
      puts "You must name your migration (CasedLikeThis)"
      exit 1
    end
    timenumber = Time.now.strftime "%Y%m%d%H%M%S"
    file = "db/migrate/#{timenumber}_#{name.snake_case}.rb"

    File.open file, "w" do |f|
      f.puts %{
class #{name} < ActiveRecord::Migration
  def change
  end
end}.strip
    end

    puts "Generated #{file}"
    exit # otherwise rake will try to run the other arguments
  end
end

desc "Generate the weekly winners playlist"
task :create_playlist do
  Playlist.weekly_winners
end

desc "Wipe users from database"
task :db_delete_users do
  User.delete_all
end

desc "Wipe playlists from database"
task :db_delete_playlists do
  Playlist.delete_all
  PlaylistSong.delete_all
end

desc "Wipe votes from database"
task :db_delete_votes do
  Vote.delete_all
end

desc "Wipe songs from database"
task :db_delete_songs do
  Song.delete_all
end

desc "Create playlist in week n."
task :create_playlist do
  require './create_playlist.rb'
end

desc "Create votes in week n."
task :create_votes do
  require './create_votes.rb'
end

desc "Create users"
task :create_users do
  require './create_users.rb'
end

desc "Create songs in week n"
task :create_songs do
  require './create_songs.rb'
end

desc "Wipe database records"
task :delete_db do
  User.delete_all
  Playlist.delete_all
  PlaylistSong.delete_all
  Vote.delete_all
  Song.delete_all
end
