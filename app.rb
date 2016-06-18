require "sinatra/base"
require "sinatra/json"
require "rack/cors"
require "date"
require "json"
require "./spotify_api"
require "./spotify_api_token"
require 'digest/sha2'

require "./db/setup"
require "./lib/all"
require 'pony'
require 'rollbar'
require 'rollbar/middleware/sinatra'

if ENV['ROLLBAR_ACCESS_TOKEN']
  Rollbar.configure do |config|
    config.access_token = ENV['ROLLBAR_ACCESS_TOKEN']
  end
end

class MyApp < Sinatra::Base
  enable :sessions
  set :session_secret, "hunter2"

  set :method_override, true

  set :logging, true

  # set :show_exceptions, false


  if ENV["SENDGRID_USERNAME"]
    Pony.options = {
      :via => :smtp,
      :via_options => {
        :address => 'smtp.sendgrid.net',
        :port => '587',
        :domain => 'alphatunez.herokuapp.com',
        :user_name => ENV['SENDGRID_USERNAME'],
        :password => ENV['SENDGRID_PASSWORD'],
        :authentication => :plain,
        :enable_starttls_auto => true
      }
    }
  end

  if ENV['ROLLBAR_ACCESS_TOKEN']
    use Rollbar::Middleware::Sinatra
  end


  use Rack::Cors do
    allow do
      origins "*"
      resource "*", headers: :any, methods: :any
    end
  end


  def require_login!
    unless current_user
    redirect '/'
    end
  end

  before do
    unless ["/", "/newuser", "/dashboard"].include?(request.path)
      require_login!
      return
    end
  end

  if ENV['PRY_ON_ERROR']
    error do |e|
      binding.pry
    end
  end

  # login page show
  get '/' do
    erb :login
  end


#account page
  get '/account' do
    erb :account
  end

  #reset password
  get '/password' do
    erb :password
  end

  post '/password' do
    if (current_user.password == Digest::SHA256.hexdigest(params[:oldpassword])) && (params[:newpassword1] == params[:newpassword2])
      change_password(params[:newpassword1])
      session[:message] = "Password Changed Successfully"
      redirect '/account'
    elsif current_user.password != Digest::SHA256.hexdigest(params[:oldpassword])
      session[:message] = "Old Password Incorrect"
      redirect '/password'
    else
      session[:message] = "New Password Did Not Match"
      redirect '/password'
    end
  end

# if login info is not found redirect to new user page
  post '/' do
    u = User.find_by(email: params[:username])
    if u && u.password == Digest::SHA256.hexdigest(params[:password])
      login_user u
      redirect '/dashboard'
    else
      @failed_login = true
      erb :login
    end
  end


  post '/logout' do
    logout
    redirect '/'
  end

  # create new user info
  #puts Digest::SHA256.hexdigest "Hello World"
  post '/newuser' do
    u = User.create!(email: params[:username], password: params[:password])
    login_user u
    session[:message] = "Account Creation Successful"
    redirect '/dashboard'
  end

  # new user page show
  get '/newuser' do
    erb :newuser
  end

  # get songs info for dashboard
  get '/dashboard' do
    @songs = Playlist.current_alpha_hash
    erb :dashboard
  end

  post '/invite' do
    unless params[:email] == ""
    Pony.mail :to => params[:email],
              :from => "friend@alphatunez.herokuapp.com",
              :headers => { 'Content-Type' => 'text/html' },
              :subject => "Welcome to AlphatuneZ!",
              :body => body = erb(:invite_email, layout: false )
    end
    session[:message] = "Email sent to #{params[:email]}"
    redirect '/dashboard'
  end

  post "/user/song/vote" do
    song = Song.find(params[:song_id])

    if params[:vote] == "up"
      vote_val = 1
    else
      vote_val = -1
    end

    if v = Vote.find_by(user_id: current_user.id, song_id: song.id)
      v.value = vote_val
    else
      v = Vote.create!(
        user_id: current_user.id,
        song_id: song.id,
        value: vote_val,
        placed_at: DateTime.now
      )
    end
    redirect '/dashboard'
  end

  def login_user user
    session[:logged_in_user_id] = user.id
    session[:message] = "Login Successful"
  end

  def logout
    session[:message] = "Logout Successful"
    session.delete :logged_in_user_id
  end

  def change_password newpassword
    c = current_user
    c.password = Digest::SHA256.hexdigest(newpassword)
    c.save!
  end

  def token_string
    session[:token_handler].access_token_type +
      " " +
      session[:token_handler].access_token
  end

  def current_user
    if id = session[:logged_in_user_id]
      User.find_by id: id
    else
      nil
    end
  end

  def parsed_body
    begin
      @parsed_body ||= JSON.parse request.body.read
    rescue
      halt 400
    end
  end

  get "/callback" do
    #session[:token_handler] = SpotifyApiToken.new code: params['code']
    # binding.pry
    # #headers: {"Authorization" => "Basic " + ENV['CLIENT_ID']},
    # my_code = params['code']
    # SpotifyApiToken.request_refresh_and_access_tokens code: my_code
    #session[:token_handler].request_refresh_and_access_tokens code: params['code']
    session[:token_handler].request_refresh_and_access_tokens params
    binding.pry
    redirect "/dashboard"
  end

  get "/api/me" do
    session[:token_handler] = SpotifyApiToken.new
    redirect(session[:token_handler].authorize!)
#    client_id = ENV['CLIENT_ID'] ||= File.read('./client_id.txt').chomp

 #   if client_id
 #     spotify_login #client_id
 #   else
 #     halt
 #   end
 # end
  end


  def spotify_login
    url = "https://accounts.spotify.com/authorize/"
    response_type = "code"
    redirect_uri = URI.encode("http://localhost:4567/callback")
    scope = URI.encode("user-read-private user-read-email")
    redirect "#{url}?client_id=#{ENV['CLIENT_ID']}&response_type=#{response_type}&redirect_uri=#{redirect_uri}&#{scope}"
  end

  post "/songs" do
    @song = Song.new(title: params[:title], artist: params[:artist], suggester_id: current_user.id)
    spotify = SpotifyApiRequest.new(
      authorization: token_string,
      song: @song.title
    )
    spotify.parse!
    @hits = spotify.get_songs
    if @hits.count == 0
      session[:message] = "No Song Found"
      redirect "/dashboard"
    else
      erb :choose_song
    end
    # rescue
    #   status 403
    #   # redirect "/dashboard"
    #   halt "Entry doesn't include Title, Artist"
  end

  post "/choose_song" do
    @song = Song.new(title: params[:title], artist: params[:artist], suggester_id: current_user.id, spotify_id: params[:spotify_id])
    if (Playlist.current.map {|s| s.spotify_id}).include?(@song.spotify_id)
      session[:message] = "Song Already On List"
      redirect '/dashboard'
    elsif @song.save!
      200
      session[:message] = "Song Added Successfully"
      redirect '/dashboard'
    else
      status 403
      session[:message] = "Song Could Not Be Added"
      redirect '/dashboard'
    end
  end

  post "/no_song" do
  session[:message] = "No Song Was Added"
  redirect '/dashboard'
  end

  delete "/songs" do
    song = Song.where(title: params[:title], suggester_id: current_user.id)
    song.delete_all
    redirect "/dashboard"
  end


  get "/winningplaylist" do
    @last_playlist = Playlist.last
    playlist = Playlist.last
    if playlist
        @songs = playlist.songs
        @last_5_playlists = Playlist.last(5)
    end
    # created_at = playlist.created_at
    # @time = Time.convert_to_US_civilian_time(created_at)
    erb :winningplaylist
  end


  get "/winningplaylist/:playlist_id" do
    @playlist = Playlist.find_by(id: params[:playlist_id])
    @songs = @playlist.songs
    erb :winningplaylist_archive
  end



  # get "/weeklyplaylist" do
  #     weekly_songs = SongList.new
  #     @winners_list = weekly_songs.generate_weekly_winners
  #     weekly_playlist = Playlist.create!(created_at: Time.now)
  #     @winners_list.each do |letter,song|
  #       if song
  #         PlaylistSong.create!(song_id: song.id, playlist_id: weekly_playlist.id)
  #       end
  #     end
  #     erb :weeklyplaylist
  # end

  get "/weeklyplaylist" do
    @winners_list = Playlist.by_week.alphabet_winners_hash
    #   select { |p| p.created_at.week_number == Time.now.week_number - 1 }.
    #   sort_by {|q| q.created_at }.
    #   reverse.
    #   first.
    #binding.pry
    erb :weeklyplaylist
  end

  get "/rekt" do
    1 / 0
  end

  run! if $PROGRAM_NAME == __FILE__
end
