require "./db/setup"
require "./lib/all"
require "./lib/time"

require "./create_songs"


p = Playlist.create!(
  created_at: week,
  title: "Best Database Playlist Ever"
)

Song.all.each do |song|
  PlaylistSong.create!(
    playlist_id: p.id,
    song_id: song.id
  )
end
