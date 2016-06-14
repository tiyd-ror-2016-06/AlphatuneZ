require 'httparty'
require 'pry'
require 'json'

Spotify_api = "https://api.spotify.com"
class SpotifyApiRequest
  attr_reader :song, :raw_data


  def initialize song:
    @song = song
    @token = ENV["SPOTIFY_TOKEN"] || File.read("./token.txt").chomp
    @raw_data = []
  end

  def self.get_song_query
    st_encoded = URI.encode @song
    HTTParty.get(
    Spotify_api + "/v1/search?q=#{st_encoded}&type=#{@type}",
    headers: { "Accept" => "application/json", "Authorization" => "Bearer " + Token }
    )
  end

  def parse!
    @type = "track"
    # if song:
    #   type = track

    # elsif album:
    #   type = album
    # end

    if ENV["TEST"]
      @raw_data = JSON.parse(File.read "spotifytest1")
    else
      @raw_data = JSON.parse(get_song_query)   #(@song))
    end
binding.pry
    24
  end


  def get_songs
    #if raw_data == []
    #return []
    #else
    raw_songs = []
    @raw_data["tracks"]["items"].each do |item|
      binding.pry
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
        each_song_array.push(song_hash)
      end
    end
  end
  # end
end
# correct
spotify = SpotifyApiRequest.new(song: "This is a song")
spotify = spotify.parse!
binding.pry
spotify.get_songs
binding.pry
