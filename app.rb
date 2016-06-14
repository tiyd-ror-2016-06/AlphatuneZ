require "sinatra/base"
require "sinatra/json"
require "rack/cors"

require "./db/setup"
require "./lib/all"

class MyApp < Sinatra::Base

  LOGGED_IN_USERS = []

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
   if User.find_by(username: params[:username], password: params[:password])
     erb :login
   else
   redirect '/newuser'
   end
 end

# create new user info
 post '/newuser' do
  User.create(username: params[:username], password: params[:password])
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

  def current_user
    LOGGED_IN_USERS.last
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


  post "/api/songs" do
    begin
      song = parsed_body
    rescue
      status 400
      halt "Can't parse json: '#{body}'"
    end
    begin
      Song.create!(title: song["title"], artist: song["artist"], suggester_id: current_user.id) #suggest_id hardcoded for testing
    rescue
      status 403
      halt "Entry doesn't include Title, Artist"
    end
    200
    json "Song added!"
  end

  delete "/api/songs" do
    if current_user
      body = parsed_body
      song = Song.where(title: body["title"], suggester_id: current_user.id).first.delete
      status 200
      json "Song deleted!"
    elsif Song.where(title: body["title"])
      status 403
      halt "You can't delete that"
    else
      status 400
      halt "This doesn't exist"
    end
  end



  run! if $PROGRAM_NAME == __FILE__
end
