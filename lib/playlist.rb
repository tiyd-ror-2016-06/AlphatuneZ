class Playlist < ActiveRecord::Base
  validates_presence_of :created_at

  has_many :playlist_songs
  has_many :songs, through: :playlist_songs

  def weekly_playlist

  end
end
