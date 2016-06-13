require 'httparty'
require 'pry'
require 'json'

Spotify_api = "https://api.spotify.com"
Token =


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
  raw_data = get_song_query("Mr. Blue Sky")
end

list_of_songs = []

# Some song Details

# songs.each do |s|
# list_of_songs.push(s)
# songs.first["album"]["name"]






# raw_songs = []
# rawdata["tracks"]["items"].each do |f|
# raw_songs.push(f)
# end


# songs.each do |s|
#   song_hash = {}
#   s.keys.each do |key|
#     case key
#     when "album"
#       #song_hash[key] = s[key]["name"]
#     when "artists"
#       song_hash["artist"] = s[key]["name"]
#     when "id"
#       song_hash["id"] = s[key]["id"]
#     when "name"
#       song_hash["title"] = s[key]["name"]
#     end
#   end
