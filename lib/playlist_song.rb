class PlaylistSong < ActiveRecord::Base
  validates_presence_of :song_id, :playlist_id

  belongs_to :playlist
  belongs_to :song
end
