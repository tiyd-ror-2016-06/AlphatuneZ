

class SpotifyApiToken

  def initialize
    @token = token
    @client_token = client_token
    @refresh_token = refresh_token
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
    unless @refresh_token
      if ENV['REFRESH_TOKEN']
        @refresh_token = ENV['REFRESH_TOKEN']
      else
        @refresh_token = File.read("./refresh_token.txt").chomp
      end
    end
    @refresh_token
  end

  def client_token
    return @client_token if @client_token
    if ENV['CLIENT_ID'] && ENV['CLIENT_SECRET']
      token_string = ENV['CLIENT_ID'] + ":" + ENV['CLIENT_SECRET']
    else
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
    end
    @client_token = "Basic " + Base64.encode64(
                      token_string
                    ).sub(/\n/,"")
  end
end
