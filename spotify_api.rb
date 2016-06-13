require 'httparty'
require 'pry'
require 'json'

Spotify_api = "https://api.spotify.com"
Token =
@token = ENV["SPOTIFY_TOKEN"] || File.read("./token.txt").chomp


def get_song_query song_title
  st_encoded = URI.encode song_title
  HTTParty.get(
    Spotify_api + "/v1/search?q=#{st_encoded}&type=track",
                headers: { "Accept" => "application/json", "Authorization" => "Bearer " + Token }
  )
end


if ENV["TEST"]
  raw_data = JSON.parse(File.read "spotifytest1")
else
  raw_data = get_song_query("empire state of mind")
end

raw_songs = []
raw_data["tracks"]["items"].each do |item|
raw_songs.push(item)
end

raw_songs.each do |song|
  song_hash = {}
  song.keys.each do |key|
    case key
    when "album"
      song_hash[key] = song[key]["name"]
    when "artists"
      song_hash["artist"] = song[key].first["name"]
      #if multiple artists just take the first artist for now.
      #question posed to slack
      #song["artists"].map { |h| h["name"] }.join(", ")
    when "id"
      song_hash["id"] = song[key]
    when "name"
      song_hash["title"] = song[key]
    end
    binding.pry
  end
end
