require "./db/setup"
require "./lib/all"

# [User, Song].each { |klass| klass.delete_all }

# def delete_users
#   User.delete_all
# end
#
# delete_users


user = User.create!(email: "mep@compuserve.com", password: "secret")

def create_playlist
  playlist = Playlist.create!(created_at: "2016-06-12 00:00:00") #DateTime.now)
  Song.last(27).each do |song|
    PlaylistSong.create!(song_id: song.id, playlist_id: playlist.id)
    end
end

Song.create!(title: "AA", artist: "Aaaartist", genre: "Pop", suggester_id: user.id)
Song.create!(title: "BB", artist: "Bartist", genre: "Pop", suggester_id: user.id)
Song.create!(title: "CC", artist: "Cartist", genre: "Pop", suggester_id: user.id)
Song.create!(title: "DD", artist: "Dartist", genre: "Pop", suggester_id: user.id)
Song.create!(title: "EE", artist: "Eartist", genre: "Pop", suggester_id: user.id)
Song.create!(title: "FF", artist: "Fartist", genre: "Pop", suggester_id: user.id)
Song.create!(title: "GG", artist: "Gartist", genre: "Pop", suggester_id: user.id)
Song.create!(title: "HH", artist: "Hartist", genre: "Pop", suggester_id: user.id)
Song.create!(title: "II", artist: "Iartist", genre: "Pop", suggester_id: user.id)
Song.create!(title: "JJ", artist: "Jartist", genre: "Pop", suggester_id: user.id)
Song.create!(title: "KK", artist: "Kartist", genre: "Pop", suggester_id: user.id)
Song.create!(title: "LL", artist: "Lartist", genre: "Pop", suggester_id: user.id)
Song.create!(title: "MM", artist: "Martist", genre: "Pop", suggester_id: user.id)
Song.create!(title: "NN", artist: "Nartist", genre: "Pop", suggester_id: user.id)
Song.create!(title: "OO", artist: "Oartist", genre: "Pop", suggester_id: user.id)
Song.create!(title: "PP", artist: "Partist", genre: "Pop", suggester_id: user.id)
Song.create!(title: "QQ", artist: "Qartist", genre: "Pop", suggester_id: user.id)
Song.create!(title: "RR", artist: "Rartist", genre: "Pop", suggester_id: user.id)
Song.create!(title: "SS", artist: "Sartist", genre: "Pop", suggester_id: user.id)
Song.create!(title: "TT", artist: "Tartist", genre: "Pop", suggester_id: user.id)
Song.create!(title: "UU", artist: "Uartist", genre: "Pop", suggester_id: user.id)
Song.create!(title: "VV", artist: "Vartist", genre: "Pop", suggester_id: user.id)
Song.create!(title: "WW", artist: "Wartist", genre: "Pop", suggester_id: user.id)
Song.create!(title: "XX", artist: "Xartist", genre: "Pop", suggester_id: user.id)
Song.create!(title: "YY", artist: "Yartist", genre: "Pop", suggester_id: user.id)
Song.create!(title: "ZZ", artist: "Zartist", genre: "Pop", suggester_id: user.id)
Song.create!(title: "33", artist: "3artist", genre: "Pop", suggester_id: user.id)


c = create_playlist
