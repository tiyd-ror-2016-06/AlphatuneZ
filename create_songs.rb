require "./db/setup"
require "./lib/all"
require "./lib/time"
require "./spotify_api"

require './create_users.rb'

def suggester_id
  User.all.sample.id
end

Dir["#{File.dirname __FILE__}/spotify_test_data/*"].each do |file|
  f = File.read(file)
  s = JSON.parse f
  Song.create!(
    title: s["title"],
    artist: s["artist"],
    genre: "datagore",
    spotify_id: s["id"],
    suggester_id: suggester_id,
    suggested_date: week
  )
end
