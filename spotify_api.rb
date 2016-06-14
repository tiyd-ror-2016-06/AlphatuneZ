require 'httparty'
require 'pry'
require 'json'

Spotify_api = "https://api.spotify.com"

class SpotifyApiRequest

  attr_reader :song, :raw_data

  def initialize song:, test_data: nil
    @song = song
    @token = nil # ENV["SPOTIFY_TOKEN"] || File.read("./token.txt").chomp
    @raw_data = []
    @test_data = test_data
  end

  def self.get_song_query
    st_encoded = URI.encode @song
    HTTParty.get(
      Spotify_api + "/v1/search?q=#{st_encoded}&type=#{@type}",
      headers: { "Accept" => "application/json", "Authorization" => "Bearer " + Token }
    )
  end

  def parse!
    if song:
         @type = "track"

      # branch to @type assignment for more user-friendly, and optimal search ?

      #elsif album: && artist:
        #@type =
    end

    if test:
      @raw_data = JSON.parse(File.read @test_data)
    else
      @raw_data = JSON.parse(get_song_query)
    end
  end


  def get_songs
    raw_data == [] && return []

    raw_songs = []
    @raw_data["tracks"]["items"].each do |item|
      raw_songs.push(item)
    end

    each_song_array = []
    raw_songs.each do |song|
      song_hash = {}
      song.keys.each do |key|
        case key
        when "album"
          song_hash[key] = song[key]["name"]
        when "artists"
          song_hash["artist"] = song[key].first["name"]
          song["artists"].map { |h| h["name"] }.join(", ")
        when "id"
          song_hash["id"] = song[key]
        when "name"
          song_hash["title"] = song[key]
        end
      end
      each_song_array.push(song_hash)
    end
    each_song_array
  end
end
