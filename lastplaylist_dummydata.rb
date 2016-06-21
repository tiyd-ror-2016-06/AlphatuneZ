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

Song.create!(title: "Asong", artist: "Aartist", genre: "Pop", spotify_id: "1", suggester_id: user.id)
Song.create!(title: "Bsong", artist: "Bartist", genre: "Pop", spotify_id: "2", suggester_id: user.id)
Song.create!(title: "Csong", artist: "Cartist", genre: "Pop", spotify_id: "3", suggester_id: user.id)
Song.create!(title: "Dsong", artist: "Dartist", genre: "Pop", spotify_id: "4", suggester_id: user.id)
Song.create!(title: "Esong", artist: "Eartist", genre: "Pop", spotify_id: "5", suggester_id: user.id)
Song.create!(title: "Fsong", artist: "Fartist", genre: "Pop", spotify_id: "6", suggester_id: user.id)
Song.create!(title: "Gsong", artist: "Gartist", genre: "Pop", spotify_id: "7", suggester_id: user.id)
Song.create!(title: "Hsong", artist: "Hartist", genre: "Pop", spotify_id: "8", suggester_id: user.id)
Song.create!(title: "Isong", artist: "Iartist", genre: "Pop", spotify_id: "9", suggester_id: user.id)
Song.create!(title: "Jsong", artist: "Jartist", genre: "Pop", spotify_id: "10", suggester_id: user.id)
Song.create!(title: "Ksong", artist: "Kartist", genre: "Pop", spotify_id: "11", suggester_id: user.id)
Song.create!(title: "Lsong", artist: "Lartist", genre: "Pop", spotify_id: "12", suggester_id: user.id)
Song.create!(title: "Msong", artist: "Martist", genre: "Pop", spotify_id: "13", suggester_id: user.id)
Song.create!(title: "Nsong", artist: "Nartist", genre: "Pop", spotify_id: "14", suggester_id: user.id)
Song.create!(title: "Osong", artist: "Oartist", genre: "Pop", spotify_id: "15", suggester_id: user.id)
Song.create!(title: "Psong", artist: "Partist", genre: "Pop", spotify_id: "16", suggester_id: user.id)
Song.create!(title: "Qsong", artist: "Qartist", genre: "Pop", spotify_id: "17", suggester_id: user.id)
Song.create!(title: "Rsong", artist: "Rartist", genre: "Pop", spotify_id: "18", suggester_id: user.id)
Song.create!(title: "Ssong", artist: "Sartist", genre: "Pop", spotify_id: "19", suggester_id: user.id)
Song.create!(title: "Tsong", artist: "Tartist", genre: "Pop", spotify_id: "20", suggester_id: user.id)
Song.create!(title: "Usong", artist: "Uartist", genre: "Pop", spotify_id: "21", suggester_id: user.id)
Song.create!(title: "Vsong", artist: "Vartist", genre: "Pop", spotify_id: "22", suggester_id: user.id)
Song.create!(title: "Wsong", artist: "Wartist", genre: "Pop", spotify_id: "23", suggester_id: user.id)
Song.create!(title: "Xsong", artist: "Xartist", genre: "Pop", spotify_id: "24", suggester_id: user.id)
Song.create!(title: "Ysong", artist: "Yartist", genre: "Pop", spotify_id: "25", suggester_id: user.id)
Song.create!(title: "Zsong", artist: "Zartist", genre: "Pop", spotify_id: "26", suggester_id: user.id)
Song.create!(title: "3song", artist: "3artist", genre: "Pop", spotify_id: "27", suggester_id: user.id)


c = create_playlist
