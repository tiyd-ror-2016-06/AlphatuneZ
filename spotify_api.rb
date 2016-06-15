require 'httparty'
require 'pry'
require 'json'

Spotify_api = "https://api.spotify.com"

class SpotifyApiRequest

  attr_reader :song, :raw_data

  def initialize song:, test_data: nil
    @song = song
    @token = generate_beginning_token #ENV["SPOTIFY_TOKEN"] # || File.read("./token.txt").chomp
    @raw_data = []
    @test_data = test_data
  end


  def generate_beginning_token
    beginning_token = refresh_access_token
  end

  # def token
  #   @token = generate_beginning_token
  # end

  def token #check_token_freshness
    if generate_beginning_token["expires_in"] = "0"
      refresh_access_token
    else
    @token
    end
  end


  def refresh_access_token
    new_token = HTTParty.post(
    'https://accounts.spotify.com/api/token',
    headers: {"Authorization" => "Basic ZGQzMmI2MTgwZDZhNGY0ZGI0Yjk3ZGU2NDVhNmNmYjM6NDczNTllNzQxNGM4NDgzYWI1MjM2NGZhYjkzNjdjOTI=\n"},
    body: {
    grant_type: "refresh_token",
    refresh_token: "AQB1I4NoUT_LE5ylmkrvWHyrxu_TNJJ0nQIL24nNgncdrxFAFc_ATeynDz6vj-RsyLUMkO0eJsGZYF6wBUu629aVBMtVU61401xAXcToXVKVFqVikJVTzRgF0yTredQ0-kw"
    })
  end



  def get_song_query
    st_encoded = URI.encode @song
    HTTParty.get(
      Spotify_api + "/v1/search?q=#{st_encoded}&type=#{@type}",
      headers: { "Accept" => "application/json", "Authorization" => "Bearer #{@token['access_token']}" }
    )
  end

  def create_playlist
    r = HTTParty.post(
      Spotify_api + "/v1/users/ferretpenguin/playlists",
      headers: { "Accept" => "application/json", "Authorization" => "Bearer #{@token['access_token']}"},
      body: {
      name: "Test Playlist",
      }.to_json)


    body = JSON.parse r.body
    @playlist_id = body["id"]
  end

  def export_songs_to_playlist
    songs_array =[]
    songs = get_songs

    songs.each do |song|
      songs_array.push "spotify:track:#{song['id']}"
    end

    r = HTTParty.post(
      Spotify_api + "/v1/users/ferretpenguin/playlists/#{@playlist_id}/tracks",
      headers: { "Accept" => "application/json", "Authorization" => "Bearer #{@token['access_token']}"},
      body: {
      uris: songs_array
      }.to_json)
  end

  def parse!
    if @song
         @type = "track"

      # branch to @type assignment for more user-friendly, and optimal search ?

      #elsif album: && artist:
        #@type =
    end

    if @test_data
      @raw_data = JSON.parse(File.read @test_data)
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
end

def no_song # title, artist
  spotify = SpotifyApiRequest.new(song: "This is a song", test_data: "spotify_test_data/spotifytest1.json")
  spotify.parse!
  hits = spotify.get_songs
end
