require 'httparty'
require 'pry'
require 'json'
require 'base64'

Spotify_api = "https://api.spotify.com"

class SpotifyApiRequest

  attr_reader :song, :raw_data

  def initialize song:, test_data: nil
    @song = song
    @client_token = client_token
    @token = generate_beginning_token
    #token #generate_beginning_token #ENV["SPOTIFY_TOKEN"] # || File.read("./token.txt").chomp
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

  # def refresh_access_token
  #   new_token = HTTParty.post(
  #   'https://accounts.spotify.com/api/token',
  #   headers: {"Authorization" => "Basic ZGQzMmI2MTgwZDZhNGY0ZGI0Yjk3ZGU2NDVhNmNmYjM6NDczNTllNzQxNGM4NDgzYWI1MjM2NGZhYjkzNjdjOTI=\n"},
  #   body: {
  #   grant_type: "refresh_token",
  #   refresh_token: "AQB1I4NoUT_LE5ylmkrvWHyrxu_TNJJ0nQIL24nNgncdrxFAFc_ATeynDz6vj-RsyLUMkO0eJsGZYF6wBUu629aVBMtVU61401xAXcToXVKVFqVikJVTzRgF0yTredQ0-kw"
  #   })
  #   new_token.merge!({"expires_at"=> Time.at(Time.now + new_token["expires_in"])})
  #   binding.pry

  # end


  def refresh_access_token
    #if new_token["expires_at"] < Time.now
      new_token = HTTParty.post(
        'https://accounts.spotify.com/api/token',
        headers: {"Authorization" => @client_token},
        body: {
          grant_type: "refresh_token",
          refresh_token: refresh_token
    })
      binding.pry
      new_token.merge!({"expires_at"=> Time.at(Time.now + new_token["expires_in"])})
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
    rescue => e
      raise e
    end

    if raw_token.values.include? ""
      raise "'token.json' doesn't include any credentials."
    end
    token_string =  raw_token["Client_ID"] + ":" + raw_token["Client_Secret"]
    binding.pry

    @client_token = "Basic " + Base64.encode64(
      raw_token["Client_ID"] + ":" + raw_token["Client_Secret"]
    ).sub(/\n/,"")
  end

  def get_song_query
    st_encoded = URI.encode @song
    HTTParty.get(
      Spotify_api + "/v1/search?q=#{st_encoded}&type=#{@type}",
      headers: { "Accept" => "application/json", "Authorization" => @token }
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
