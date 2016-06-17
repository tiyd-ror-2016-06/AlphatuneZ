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

  def total_votes_current_week
    #votes.where(placed_at: 6.days.ago .. Time.now).pluck(:value).reduce(0,:+)
    votes.
      select { |o| o.song.suggested_date.week_number == Time.now.week_number }.
      map { |p| p.value }.
      reduce(0,:+)
  end

  def alpha_categorize
    if self.standardized_title[0].nil?
      "#"
    elsif self.standardized_title[0].to_i.to_s != self.standardized_title[0]
      self.standardized_title[0].upcase
    else
      "#"
    end
  end


end
