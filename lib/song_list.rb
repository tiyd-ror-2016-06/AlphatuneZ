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
    songs.group_by{ |s| categorize(s)}
  end
end
