class FavoriteSong < ActiveRecord::Base
  validates_presence_of :user_id, :song_id

  belongs_to :user
  belongs_to :song
  
  has_many :favorites, through: :favorite_songs, source: :favorites
  has_many :songs, through: :favorite_songs, source: :favorites

end
