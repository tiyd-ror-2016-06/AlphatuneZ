class Playlist < ActiveRecord::Base
  validates_presence_of :created_at

  has_many :playlist_songs
  has_many :songs, through: :playlist_songs

  def alphabetized_hash
    songs.group_by{ |s| s.alpha_categorize }
  end

  def alphabet_winners_hash
    Hash[self.alphabetized_hash.map { |k,a| [k,a.max_by {|song| song.total_votes_current_week }]}]
  end

  def self.current
    Song.all.select { |song| song.suggested_date.week_number == Time.now.week_number }
  end

  def self.current_alpha_hash
    Hash[(self.current.group_by{ |s| s.alpha_categorize }).sort]
  end

  def self.by_week week=-1
    pweek = Time.now.week_number + week
      p = self.create!(created_at: Time.now)
    Song.all.select { |song| song.suggested_date.week_number == pweek }.each do |s|
      PlaylistSong.create!(song_id: s.id, playlist_id: p.id)
    end
    p
  end

  def self.weekly_winners
    p = self.by_week.alphabetized_hash
    wp = self.create!(created_at: Time.now)
    p.each do |letter, songs|
      winner = p[letter].max_by { |song| song.total_votes_current_week}
      PlaylistSong.create!(song_id: winner.id, playlist_id: wp.id)
    end
    return wp
  end

end
