class User < ActiveRecord::Base
  before_create :encrypt

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true # TODO: length ?

  has_many :suggested_songs, class_name: "Song", foreign_key: :suggester_id

  has_many :votes
  has_many :voted_songs, through: :votes, source: :song
  has_many :favorite_songs
  has_many :favorites, through: :favorite_songs, source: :songs 

  def points
    results = []
    suggested_songs.find_each do |song|
      song.votes.find_each do |vote|
        results.push vote.value
      end
    end
    results.reduce :+
  end

  def encrypt
    self.password = Digest::SHA256.hexdigest(self.password)
  end

end
