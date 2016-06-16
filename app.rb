require "sinatra/base"
require "sinatra/json"
require "rack/cors"
require "date"
require "json"
require "./spotify_api"
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
    User.create!(email: params[:username], password: params[:password])
    redirect '/'
  end

  # new user page show
  get '/newuser' do
    erb :newuser
  end

  # get songs info for dashboard
  get '/dashboard' do
    list = SongList.new
    @songs = list.get_list
    erb :dashboard
  end

  post '/invite' do
    if params[:email] == ""
    else
    Pony.mail :to => params[:email],
              :from => "friend@alphatunez.com",
              :subject => "Welcome to AlphatuneZ!",
              :body => body = erb(:invite_email, layout: false )
    end
              redirect '/'
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
  end

  def logout
    session.delete :logged_in_user_id
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

  get "/api/me" do
    if current_user
      json current_user
    else
      status 401
    end
  end


  post "/songs" do
    @song = Song.new(title: params[:title], artist: params[:artist], suggester_id: current_user.id)
    spotify = SpotifyApiRequest.new(song: "This is a song", test_data: "spotify_test_data/spotifytest1.json")
    spotify.parse!
    hits = spotify.get_songs
    if hits.count == 0
      @no_song = true
      erb :dashboard

    elsif @song.save!
      200
      redirect '/dashboard'
    else
      403
      erb
    end
    # rescue
    #   status 403
    #   # redirect "/dashboard"
    #   halt "Entry doesn't include Title, Artist"
  end

  delete "/songs" do
    song = Song.where(title: params[:title], suggester_id: current_user.id)
    song.delete_all
    redirect "/dashboard"
  end

  get "/weeklyplaylist" do
      weekly_songs = SongList.new
      @winners_list = weekly_songs.generate_weekly_winners
      weekly_playlist = Playlist.create!(created_at: Time.now)
      @winners_list.each do |letter,song|
        if song
          PlaylistSong.create!(song_id: song.id, playlist_id: weekly_playlist.id)
        end
      end
      erb :weeklyplaylist
  end

  get "/rekt" do
    1 / 0
  end

  run! if $PROGRAM_NAME == __FILE__
end
