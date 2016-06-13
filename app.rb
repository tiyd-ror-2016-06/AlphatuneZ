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

  get "/api/me" do
    if current_user
      json current_user
    else
      status 401
    end
  end

  run! if $PROGRAM_NAME == __FILE__
end
