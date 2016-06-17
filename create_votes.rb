require "./db/setup"
require "./lib/all"
require "./lib/time"

require './create_songs'
require './create_users'

def random_vote
  x = {
    0 => -1,
    1 => 1
  }
  x[rand(2)]
end

User.all.each do |user|
  Song.all.each do |song|
    begin
      Vote.create!(
        song_id: song.id,
        user_id: user.id,
        value: random_vote,
        placed_at: week
      )
    rescue ActiveRecord::RecordInvalid
    end
  end
end
