require "./db/setup"
require "./lib/all"

class SongList
  attr_reader :songs

  def initialize
    @songs = Song.all
  end

  def categorize song
    if song.standardized_title[0].nil?
      "#"
    elsif song.standardized_title[0].to_i.to_s != song.standardized_title[0]
      song.standardized_title[0].upcase
    else
      "#"
    end
  end

  def get_list
    Hash[(songs.group_by{ |s| categorize(s)}).sort]
  end


  def generate_weekly_winners
    list = get_list
    winners = {}
    list.each do |letter,songs|
      winner = list[letter].max_by { |song| song.total_votes}
      winners[letter] = winner
    end
    return winners
    # list.map do |letter,songs|
    #   songs.max_by do |song|
    #   song.total_votes
    #   end
    # end
  end



end
