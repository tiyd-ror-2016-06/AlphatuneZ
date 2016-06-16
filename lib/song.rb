class Song < ActiveRecord::Base
  validates_presence_of :title, :artist, :suggester_id, :spotify_id

  belongs_to :suggester, class_name: "User"

  has_many :votes
  has_many :voters, through: :votes, source: :user

  has_many :playlist_songs
  has_many :playlists, through: :playlist_songs


  def standardized_title
    self.title.gsub(/[^a-zA-Z0-9]/, "")
  end

  def total_votes
    votes.where(placed_at: 6.days.ago .. Time.now).pluck(:value).reduce(0,:+)
  end
end
