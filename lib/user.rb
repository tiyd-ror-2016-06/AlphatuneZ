class User < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true # TODO: length ?

  has_many :suggested_songs, class_name: "Song", foreign_key: :suggester_id

  has_many :votes
  has_many :voted_songs, through: :votes, source: :song
end
