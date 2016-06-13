require 'pry'
require 'minitest/autorun'
require 'minitest/focus'

require 'minitest/reporters'
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

require "./db/setup"
require "./lib/all"

class TestSongOrder < Minitest::Test

  def setup
    [User, Song].each { |klass| klass.delete_all }
  end

  def test_can_standardize_song_names
    Song.create!(title: "(($%#R))",artist: "Xenu",genre: "Scientology Hymn", suggester_id: 1)
    song_title = Song.first.standardized_title

    assert_equal "R", song_title
  end
end
