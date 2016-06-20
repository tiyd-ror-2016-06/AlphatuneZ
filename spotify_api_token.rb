#Callback_uri = "http://localhost:4567/callback"
Callback_uri = "http://alphatunez.herokuapp.com/callback"

class SpotifyApiToken

  attr_reader :access_token_type

  def authorize! state
    url = "https://accounts.spotify.com/authorize/"
    response_type = "code"
    redirect_uri = URI.encode(Callback_uri)
    scope = URI.encode("user-read-private user-read-email")
    direct = "#{url}?client_id=#{client_id}&response_type=#{response_type}&redirect_uri=#{redirect_uri}&state=#{state}&#{scope}"
    return direct
  end

  def request_refresh_and_access_tokens parameters
    code = parameters["code"]
    url = "https://accounts.spotify.com/api/token"
    response = HTTParty.post(
      url,
      headers: {
        "Authorization" => client_creds_encrypted,
      },
      body: {
        grant_type: "authorization_code",
        redirect_uri: Callback_uri,
        code: code
      })

    @access_token = response["access_token"]
    @access_token_type = response["token_type"]
    @access_token_expiration = Time.at(Time.now + response["expires_in"])
    @refresh_token = response["refresh_token"]
  end

  #private

  def access_token
    if @access_token_expiration < Time.now
      @access_token = get_new_token
    end
    @access_token
  end

  def get_new_token
    response = HTTParty.post(
        'https://accounts.spotify.com/api/token',
        headers: {"Authorization" => client_creds_encrypted},
        body: {
          grant_type: "refresh_token",
          refresh_token: @refresh_token
        })
    @access_token_type = response["token_type"]
    @access_token_expiration = Time.at(Time.now + response["expires_in"])
    @access_token = response["access_token"]
  end

  def client_id
    ENV["CLIENT_ID"] || File.read("./client_id.txt").chomp
  end

  def client_secret
    ENV['CLIENT_SECRET'] || File.read("./client_secret.txt").chomp
  end

  def client_creds_encrypted
    token_string =
      client_id +
      ":" +
      client_secret

    "Basic " +
      Base64.strict_encode64(  token_string  )
  end

end
