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

  get '/' do
    erb :login
  end

  get '/dashboard' do
    list = SongList.new
    @songs = list.get_list
    # binding.pry
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
