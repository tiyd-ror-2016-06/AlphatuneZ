require "sinatra/base"
require "sinatra/json"
require "rack/cors"
require "date"

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

  post "/:user/:song/:vote" do
  user = User.find(params[:user])
  song = Song.find(params[:song])
  binding.pry
    if user
      if params[:vote] == "up"
        vote_val = 1
        binding.pry
      else
        vote_val = -1
      end
      v = Vote.create!(user: user.id, song: song.id, vote: vote_val, placed_at: DateTime.now)

      binding.pry

      v.to_json


    else
      status 404, json(error: "User not found")
    end
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
