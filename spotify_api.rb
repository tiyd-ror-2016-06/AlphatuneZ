require 'httparty'
require 'pry'
require 'json'
require 'base64'

Spotify_api = "https://api.spotify.com"

class SpotifyApiRequest

  attr_reader :song, :raw_data

  def initialize song:, test_data: nil
    @song = song
    @token = token
    @client_token = client_token
    @refresh_token = refresh_token
    @raw_data = []
    @test_data = test_data
  end

  def token
    if @token.nil? || @token_expiration < Time.now
      @token = get_new_token
    end
    @token
  end

  def get_new_token
    new_token = HTTParty.post(
        'https://accounts.spotify.com/api/token',
        headers: {"Authorization" => client_token},
        body: {
          grant_type: "refresh_token",
          refresh_token: refresh_token
        })
    @token_expiration = Time.at(Time.now + new_token["expires_in"])
    new_token["token_type"] + " " + new_token["access_token"]
  end

  def refresh_token
    "AQB1I4NoUT_LE5ylmkrvWHyrxu_TNJJ0nQIL24nNgncdrxFAFc_ATeynDz6vj-RsyLUMkO0eJsGZYF6wBUu629aVBMtVU61401xAXcToXVKVFqVikJVTzRgF0yTredQ0-kw"
  end

  def client_token
    return @client_token if @client_token
    token_file = './token.json'
    begin
      raw_token = JSON.parse(File.read token_file)
    rescue JSON::ParserError
      raise "There was a problem parsing your token.json file"
    rescue Errno::ENOENT
      raise "No 'token.json' file found."
    end

    if raw_token.values.include? ""
      raise "'token.json' doesn't include any credentials."
    end
    token_string =  raw_token["Client_ID"] + ":" + raw_token["Client_Secret"]

    @client_token = "Basic " + Base64.encode64(
      raw_token["Client_ID"] + ":" + raw_token["Client_Secret"]
    ).sub(/\n/,"")
  end

  def get_song_query
    st_encoded = URI.encode @song
    HTTParty.get(
      Spotify_api + "/v1/search?q=#{st_encoded}&type=#{@type}",
      headers: { "Accept" => "application/json", "Authorization" => token }
    )
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
