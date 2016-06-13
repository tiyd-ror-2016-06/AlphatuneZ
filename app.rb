require "sinatra/base"
require "sinatra/json"
require "rack/cors"
require "date"
require "json"

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

    if song == nil
      halt 403
      JSON error: "Song does not exist"
    end

    if user
      if params[:vote] == "up"
        vote_val = 1
      else
        vote_val = -1
      end
      v = Vote.create!(user_id: user.id, song_id: song.id, value: vote_val, placed_at: DateTime.now)

      v.to_json
    else
      status 403
      JSON error: "User not found"
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
