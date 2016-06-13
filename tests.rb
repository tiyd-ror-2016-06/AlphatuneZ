ENV["TEST"] = "true"

require 'pry'
require 'minitest/autorun'
require 'minitest/focus'

require 'minitest/reporters'
Minitest::Reporters.use! Minitest::Reporters::ProgressReporter.new

require 'rack/test'
require './app'

class UserTests < Minitest::Test
  include Rack::Test::Methods

  def app
    MyApp
  end

  def setup
    User.delete_all
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
end
