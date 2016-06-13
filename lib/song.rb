class Song < ActiveRecord::Base
  validates_presence_of :title, :artist, :suggester_id

  belongs_to :suggester, class_name: "User"

  has_many :votes
  has_many :voters, through: :votes, source: :user

  has_many :playlist_songs
  has_many :playlists, through: :playlist_songs
end
