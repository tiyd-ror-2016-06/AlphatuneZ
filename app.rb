require "sinatra/base"
require "sinatra/json"
require "rack/cors"
require "date"
require "json"
require "./spotify_api"

require "./db/setup"
require "./lib/all"

class MyApp < Sinatra::Base
  enable :sessions
  set :session_secret, "hunter2"

  set :logging, true
  set :show_exceptions, false

  use Rack::Cors do
    allow do
      origins "*"
      resource "*", headers: :any, methods: :any
    end
  end

  error do |e|
    if e.is_a? ActiveRecord::RecordNotFound
      halt 404, json(error: "Not Found")
    elsif e.is_a? ActiveRecord::RecordInvalid
      halt 422, json(error: e.message)
    else
      # raise e
      puts e.message
    end
  end
  # login page show
  get '/' do
    erb :login
  end

  # if login info is not found redirect to new user page
  post '/' do
    if u = User.find_by(email: params[:username], password: params[:password])
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

  post "/:user/:song/:vote" do
    song = Song.find(params[:song])

    if song == nil
      halt 403
      JSON error: "Song does not exist"
    end

    if current_user
      if params[:vote] == "up"
        vote_val = 1
      else
        vote_val = -1
      end
      v = Vote.create!(user_id: current_user.id, song_id: song.id, value: vote_val, placed_at: DateTime.now)

      v.to_json
    else
      status 403
      JSON error: "User not found"
    end
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
      binding.pry
      redirect '/dashboard'
      binding.pry
    else
      403
      erb
    end
    # rescue
    #   status 403
    #   # redirect "/dashboard"
    #   halt "Entry doesn't include Title, Artist"
  end


  post "/delete" do
    song = Song.where(title: params[:title], suggester_id: current_user.id)
    if song == []
      status 200
      redirect "/dashboard"
    end
    if song.first.delete
      status 200
      redirect "/dashboard"
    else
      status 403
      erb
    end
  end

  run! if $PROGRAM_NAME == __FILE__
end
