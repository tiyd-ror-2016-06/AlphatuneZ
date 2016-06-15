require 'httparty'
require 'pry'
require 'json'
require './spotify_api.rb'

spotify = SpotifyApiRequest.new(song: "This is a song", test_data: "spotify_test_data/spotifytest1.json")



# spotify.parse!
# songs = spotify.get_songs
# g = spotify.get_song_query

generate = spotify.generate_beginning_token
refresh = spotify.refresh_access_token
t = spotify.token
binding.pry
@no_song
