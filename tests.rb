ENV["TEST"] = "true"

require 'pry'
require 'minitest/autorun'
require 'minitest/focus'

require 'minitest/reporters'
Minitest::Reporters.use! Minitest::Reporters::ProgressReporter.new

require 'rack/test'
require './app'



focus
def test_users_can_upvote_songs
  song = Song.where(title: "Bohemian Rhapsody", artist: "Queen", genre: "Classic Rock").first_or_create!
  binding.pry
  user = User.where(email: "jorgevp5@gmail.com", password: "password").first_or_create!
  post "/#{user.id}/#{song.id}/up"
  binding.pry
  assert_equal 1, song.votes.value

end


def test_users_can_downvote_songs


end
