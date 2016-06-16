require "./db/setup"
require "./lib/all"

# [User, Song].each { |klass| klass.delete_all }

user = User.create!(email: "t@compuserve.com", password: "secret")

def create_playlist
  playlist = Playlist.create!(created_at: DateTime.now)
  Song.last(27).each do |song|
    PlaylistSong.create!(song_id: song.id, playlist_id: playlist.id)
    end
end

Song.create!(title: "Asong", artist: "Aartist", genre: "Pop", suggester_id: user.id)
Song.create!(title: "Bsong", artist: "Bartist", genre: "Pop", suggester_id: user.id)
Song.create!(title: "Csong", artist: "Cartist", genre: "Pop", suggester_id: user.id)
Song.create!(title: "Dsong", artist: "Dartist", genre: "Pop", suggester_id: user.id)
Song.create!(title: "Esong", artist: "Eartist", genre: "Pop", suggester_id: user.id)
Song.create!(title: "Fsong", artist: "Fartist", genre: "Pop", suggester_id: user.id)
Song.create!(title: "Gsong", artist: "Gartist", genre: "Pop", suggester_id: user.id)
Song.create!(title: "Hsong", artist: "Hartist", genre: "Pop", suggester_id: user.id)
Song.create!(title: "Isong", artist: "Iartist", genre: "Pop", suggester_id: user.id)
Song.create!(title: "Jsong", artist: "Jartist", genre: "Pop", suggester_id: user.id)
Song.create!(title: "Ksong", artist: "Kartist", genre: "Pop", suggester_id: user.id)
Song.create!(title: "Lsong", artist: "Lartist", genre: "Pop", suggester_id: user.id)
Song.create!(title: "Msong", artist: "Martist", genre: "Pop", suggester_id: user.id)
Song.create!(title: "Nsong", artist: "Nartist", genre: "Pop", suggester_id: user.id)
Song.create!(title: "Osong", artist: "Oartist", genre: "Pop", suggester_id: user.id)
Song.create!(title: "Psong", artist: "Partist", genre: "Pop", suggester_id: user.id)
Song.create!(title: "Qsong", artist: "Qartist", genre: "Pop", suggester_id: user.id)
Song.create!(title: "Rsong", artist: "Rartist", genre: "Pop", suggester_id: user.id)
Song.create!(title: "Ssong", artist: "Sartist", genre: "Pop", suggester_id: user.id)
Song.create!(title: "Tsong", artist: "Tartist", genre: "Pop", suggester_id: user.id)
Song.create!(title: "Usong", artist: "Uartist", genre: "Pop", suggester_id: user.id)
Song.create!(title: "Vsong", artist: "Vartist", genre: "Pop", suggester_id: user.id)
Song.create!(title: "Wsong", artist: "Wartist", genre: "Pop", suggester_id: user.id)
Song.create!(title: "Xsong", artist: "Xartist", genre: "Pop", suggester_id: user.id)
Song.create!(title: "Ysong", artist: "Yartist", genre: "Pop", suggester_id: user.id)
Song.create!(title: "Zsong", artist: "Zartist", genre: "Pop", suggester_id: user.id)
Song.create!(title: "3song", artist: "3artist", genre: "Pop", suggester_id: user.id)


c = create_playlist
