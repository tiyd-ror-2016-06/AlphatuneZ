require 'httparty'
require 'pry'
require 'json'
require './spotify_api.rb'

def help_message
  puts <<HELP_MESSAGE

HELP:

Use 'spotify_api_tester.rb test' to read a test file; optionally, specify the testfile.
Use 'spotify_api_tester.rb live' to make a spotify api request; optionally, specify a query.'

HELP_MESSAGE
  exit
end

def write_song_to_file song
  f = File.new("./spotify_test_data/spotifysong-" + Time.now.tv_sec.to_s, "w")
  spotify_request = SpotifyApiRequest.new(song: song)
  spotify_request.parse!
  f << spotify_request.get_songs.first.to_json
  f.close
end


unless ARGV.count > 0
  help_message
end

command = ARGV.shift
test_file = nil
song = nil

if command == 'test'
  unless test_file = ARGV.shift
    test_file = './spotify_test_data/spotifytest1.json'
  end
elsif command == 'live'
  unless song = ARGV.shift
    song = "I should have been a cowboy" # I should've learned to rope and ride
  end
elsif command == 'write'
  binding.pry
  exit
else
  help_message
end


spotify_request = SpotifyApiRequest.new(song: song, test_file: test_file)
parsed_request = spotify_request.clone
parsed_request.parse!
songs = parsed_request.get_songs
puts("\nMethods:\n\n", spotify_request.methods - spotify_request.class.methods)
binding.pry
