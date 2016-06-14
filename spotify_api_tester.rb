require 'httparty'
require 'pry'
require 'json'
require './spotify_api.rb'

spotify = SpotifyApiRequest.new(song: "This is a song")

spotify.parse!
spotify.get_songs
binding.pry
