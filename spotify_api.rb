require 'httparty'
require 'pry'
require 'json'
require 'base64'
require './spotify_api_token'

Spotify_api = "https://api.spotify.com"

class SpotifyApiRequest

  attr_reader :song, :raw_data, :token

  def initialize song:, test_file: nil
    @song = song
    @token_manager = SpotifyApiToken.new
    @token = @token_manager.token
    @raw_data = []
    @test_file = test_file
  end

  def get_song_query
    st_encoded = URI.encode @song
    HTTParty.get(
      Spotify_api + "/v1/search?q=#{st_encoded}&type=#{@type}",
      headers: { "Accept" => "application/json", "Authorization" => token }
    )
  end

  def export_playlist playlist
    playlist.spotify_id = create_playlist
    playlist.save!
    export_songs_to_playlist playlist
  end

  def parse!
    if @song
         @type = "track"

      # branch to @type assignment for more user-friendly, and optimal search ?

      #elsif album: && artist:
        #@type =
    end

    if @test_file
      @raw_data = JSON.parse(File.read @test_file)
    else
      @raw_data = get_song_query
    end
  end


  def get_songs
    return [] if raw_data == []

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

  private # --- Everything from here down is only callable from this object ----

  def create_playlist
    r = HTTParty.post(
      Spotify_api + "/v1/users/ferretpenguin/playlists",
      headers: { "Accept" => "application/json", "Authorization" => token},
      body: {
      name: "Weekly Playlist",
      }.to_json)


    body = JSON.parse r.body
    body["id"]
  end

  def export_songs_to_playlist playlist
    tracks_array =[]
    # This could be changed to parse through the winning playlist hash
    songs = playlist.songs

    songs.each do |song|
      tracks_array.push "spotify:track:#{song.spotify_id}"
    end

    r = HTTParty.post(
      Spotify_api + "/v1/users/ferretpenguin/playlists/#{playlist.spotify_id}/tracks",
      headers: { "Accept" => "application/json", "Authorization" => token},
      body: {
      uris: tracks_array
      }.to_json)
  end
end
