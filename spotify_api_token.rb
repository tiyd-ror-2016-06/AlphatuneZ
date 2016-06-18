

class SpotifyApiToken


  def initialize code: nil
    #request_refresh_and_access_tokens code: code

    #    @client_id = ENV['CLIENT_ID']
    @client_id = client_id
    @client_secret = client_secret
    @client_creds_encrypted = client_creds_encrypted
    #@token = token
    #@client_id = ENV['CLIENT_ID']
    #@code = ENV['SPOTIFY_CODE']

    #@client_token = client_token
    #@refresh_token = refresh_token

  end

  def authorize!
    url = "https://accounts.spotify.com/authorize/"
    response_type = "code"
    redirect_uri = URI.encode("http://localhost:4567/callback")
    scope = URI.encode("user-read-private user-read-email")
    direct = "#{url}?client_id=#{@client_id}&response_type=#{response_type}&redirect_uri=#{redirect_uri}&#{scope}"
    return direct
  end

  def access_token
    if @access_token_expiration < Time.now
      @access_token = get_new_token
    end
    @access_token
  end

  # def token
  #   if @token.nil? || @token_expiration < Time.now
  #     @token = get_new_token
  #   end
  #   @token
  # end

  def get_new_token
    response = HTTParty.post(
        'https://accounts.spotify.com/api/token',
        headers: {"Authorization" => @client_creds_encrypted},
        body: {
          grant_type: "refresh_token",
          refresh_token: @refresh_token
        })
    @access_token_type = response["token_type"]
    @access_token_expiration = Time.at(Time.now + response["expires_in"])
    @access_token = response["access_token"]
  end





#  def get_new_token
#    new_token = HTTParty.post(
#        'https://accounts.spotify.com/api/token',
#        headers: {"Authorization" => client_id},
#        body: {
#          grant_type: "refresh_token",
#          refresh_token: refresh_token
#        })
#    @token_expiration = Time.at(Time.now + new_token["expires_in"])
#    new_token["token_type"] + " " + new_token["access_token"]
#  end

  def request_refresh_and_access_tokens parameters
    code = parameters["code"]
    url = "https://accounts.spotify.com/api/token"
    response = HTTParty.post(
      url,
      headers: {
        "Authorization" => @client_creds_encrypted,
      },
      body: {
        grant_type: "authorization_code",
        redirect_uri: 'http://localhost:4567/callback',
        code: code
      })

    @access_token = response["access_token"]
    @access_token_type = response["token_type"]
    @access_token_expiration = Time.at(Time.now + response["expires_in"])
    @refresh_token = response["refresh_token"]
  end

  def client_id
    ENV["CLIENT_ID"] || File.read("./client_id.txt").chomp
  end

  def client_secret
    ENV['CLIENT_SECRET'] || File.read("./client_secret.txt").chomp
  end


  # def SpotifyApiToken.request_refresh_and_access_tokens code:
  #   url = "https://accounts.spotify.com/api/token"
  #   response = HTTParty.post(
  #     url,
  #     body: {
  #       grant_type: "authorization_code",
  #       redirect_uri: 'http://localhost:4567/callback',
  #       code: code,
  #       client_id:
  #       client_secret:
  #     })
  #   binding.pry
  # end

#    new_token = HTTParty.post(
#        'https://accounts.spotify.com/api/token',
#        headers: {"Authorization" => client_id},
#        body: {
#          grant_type: "refresh_token",
#          refresh_token: refresh_token
#        })
#    @token_expiration = Time.at(Time.now + new_token["expires_in"])
#    new_token["token_type"] + " " + new_token["access_token"]
#end

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
    if ENV['CLIENT_ID']
    #if ENV['CLIENT_ID'] && ENV['CLIENT_SECRET']
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

  def client_creds_encrypted
    token_string =  @client_id + ":" + @client_secret
    "Basic " + Base64.encode64(
      token_string
    ).sub(/\n/,"")
    "Basic " + Base64.strict_encode64(
      token_string
    )
  end

end
