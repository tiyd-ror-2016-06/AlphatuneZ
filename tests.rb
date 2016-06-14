ENV["TEST"] = "true"

require 'pry'
require 'minitest/autorun'
require 'minitest/focus'

require 'minitest/reporters'
Minitest::Reporters.use! Minitest::Reporters::ProgressReporter.new

require 'rack/test'
require './app'
# require './lib'

class UserTests < Minitest::Test
  include Rack::Test::Methods

  def app
    MyApp
  end


  def setup
    MyApp::LOGGED_IN_USERS.clear
    User.delete_all
    Song.delete_all
  end


  def login_as user
    MyApp::LOGGED_IN_USERS.push user
  end


  def test_can_fake_logged_in_requests
    user = User.create! email: "art@example.com", password: "password"
    login_as user

    response = get "/api/me"
    assert_equal 200, response.status

    body = JSON.parse response.body
    assert_equal "art@example.com", body["email"]
  end


  def test_isnt_logged_in_unless_you_say_so
    response = get "/api/me"

    assert_equal 401, response.status
  end

  def fake_song
    {"title" => "songblah",
    "artist" => "singerblah",
    "suggester_id" => 1}.to_json
  end


  def parsed_body
    begin
      @parsed_body ||= JSON.parse request.body.read
    rescue
      halt 400
    end
  end


  def test_user_can_post_songs
    # header "Authorization", user.email #or is it user.email or user.spotify_name or #user.spotify_id?
    user = User.create! email: "blah@example.com", password: "password"
    login_as user
    assert_equal 0, Song.count

    r = post "/api/songs", body = fake_song

    assert_equal 200, r.status
    assert_equal 1, Song.count
  end


  def test_user_can_delete_songs
    user = User.create! email: "art@example.com", password: "password"
    login_as user
    song1 = user.suggested_songs.create! title: "songtitle", artist: "songartist"
    song2 = user.suggested_songs.create! title: "songtitle", artist: "songartist"

    assert_equal 2, Song.count

    r = delete "/api/songs", body = song1.to_json

    assert_equal 200, r.status
    assert_equal 1, Song.count
  end


#I think i have the address for these next post/delete requests right? Not entirely sure...
  def test_user_can_save_songs_to_their_own_page
    skip
    user = User.create! email: "dootdoot@example.com", password: "password"
    login_as user
    assert_equal 0, Song.count

    r = post "/api/:user", body = fake_song

    assert_equal 200, r.status
    assert_equal 1, Song.count
  end


  def test_user_can_delete_songs_fron_their_own_page
    skip
    user = User.create! email: "art@example.com", password: "password"
    login_as user
    song1 = Song.create! title: "songtitle", artist: "songartist", suggester_id: user.id
    song2 = Song.create! title: "songtitle", artist: "songartist", suggester_id: user.id

    assert_equal 2, Song.count

    r = delete "/api/:user", body = song1.to_json

    assert_equal 200, r.status
    assert_equal 1, Song.count
  end

  def test_users_can_upvote_songs
    song = Song.where(title: "Bohemian Rhapsody", artist: "Queen", genre: "Classic Rock", suggester_id: 1).first_or_create!
    user = User.where(email: "jorgevp5@gmail.com", password: "password").first_or_create!
    login_as user
    r = post "/#{user.id}/#{song.id}/up"

    assert_equal 1, Vote.where(user_id: user.id).first.value

  end

  def test_users_can_downvote_songs
    song = Song.where(title: "Bohemian Rhapsody", artist: "Queen", genre: "Classic Rock", suggester_id: 1).first_or_create!
    user = User.where(email: "jorgevp5@gmail.com", password: "password").first_or_create!
    login_as user
    r = post "/#{user.id}/#{song.id}/down"

    assert_equal 200, r.status
    assert_equal -1, Vote.where(user_id: user.id).first.value

  end

  def test_cannot_vote_if_user_does_not_exist
    song = Song.where(title: "Bohemian Rhapsody", artist: "Queen", genre: "Classic Rock", suggester_id: 1).first_or_create!
    r = post "/500000/#{song.id}/up"
    body = JSON.parse r.body

    assert_equal 403, r.status
    assert_equal "User not found", body["error"]

  end

  def test_cannot_vote_if_song_does_not_exist
    user = User.where(email: "jorgevp5@gmail.com", password: "password").first_or_create!
    login_as user
    r = post "/#{user.id}/70000000000000/down"
    body = JSON.parse r.body

    assert_equal 404, r.status
    assert_equal "Not Found", body["error"]
  end

  def test_user_cant_post_same_song_twice
    skip
  end

  def test_user_can_only_post_spotify_song
    skip
  end

end
