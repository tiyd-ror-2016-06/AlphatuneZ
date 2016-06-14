require 'httparty'
require 'pry'
require 'json'
require './spotify_api.rb'

spotify = SpotifyApiRequest.new(song: "This is a song", test_data: "spotify_test_data/spotifytest1.json")

spotify.parse!
songs = spotify.get_songs
binding.pry
