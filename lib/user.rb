class User < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true # TODO: length ?

  has_many :suggested_songs, class_name: "Song"

  has_many :votes
  has_many :voted_songs, through: :votes, source: :song
end
