require "./db/setup"
require "./lib/all"

# [User, Song].each { |klass| klass.delete_all }

user = User.create!(email: "fake@compuserve.com", password: "password")

# def create_playlist
#   playlist = Playlist.create!(created_at: DateTime.now)
#   Song.all.each do |song|
#     PlaylistSong.create!(song_id: song.id, playlist_id: playlist.id)
#     end
# end

#A
Song.create!(title: "Absolutely (Story of a Girl)",artist: "Nine Days",genre: "Pop", suggester_id: user.id)
Song.create!(title: "Always",artist: "Saliva",genre: "Alternative", suggester_id: user.id)

#B
Song.create!(title: "Baby Got Back",artist: "Sir Mix-A-Lot",genre: "Rap", suggester_id: user.id)

#C
Song.create!(title: "C.R.E.A.M.",artist: "Wu-Tang Clan",genre: "Rap", suggester_id: user.id)

#D
Song.create!(title: "Dead",artist: "My Chemical Romance",genre: "Emo", suggester_id: user.id)
Song.create!(title: "Devil Went Down to Georgia",artist: "The Charlie Daniels Band",genre: "Country", suggester_id: user.id)

#E
Song.create!(title: "Empire State Of Mind",artist: "Jay-Z",genre: "Rap", suggester_id: user.id)
Song.create!(title: "(Everything I Do) I Do It For You",artist: "Bryan Adams",genre: "Soundtrack", suggester_id: user.id)

#F
Song.create!(title: "Fancy",artist: "Iggy Azalea",genre: "Pop", suggester_id: user.id)

#G
Song.create!(title: "Gonna Get Over You",artist: "Sara Bareilles",genre: "Pop", suggester_id: user.id)

#H
Song.create!(title: "Halleluja",artist: "Rufus Wainwright",genre: "Indie", suggester_id: user.id)

#I
Song.create!(title: "Ice Cream Paint Job",artist: "Dorrough Music",genre: "Rap", suggester_id: user.id)

#J
Song.create!(title: "Julia",artist: "Horror Pops",genre: "Alternative", suggester_id: user.id)

#K
Song.create!(title: "Karma Chameleon",artist: "Culture Club",genre: "Techno", suggester_id: user.id)

#L
Song.create!(title: "Love Story",artist: "Taylor Swift",genre: "Pop", suggester_id: user.id)

#M
Song.create!(title: "Monkey Wrench",artist: "Foo Fighters",genre: "Punk", suggester_id: user.id)

#N
Song.create!(title: "Naturally",artist: "Selena Gomez",genre: "Pop", suggester_id: user.id)

#O
Song.create!(title: "Outkast",artist: "P.O.D.",genre: "Alternative", suggester_id: user.id)

#P
Song.create!(title: "Phantom Of The Opera",artist: "Me First and the Gimmie-gimmies",genre: "Alternative", suggester_id: user.id)

#Q
Song.create!(title: "Queen Bitch",artist: "David Bowie",genre: "Pop", suggester_id: user.id)

#R
Song.create!(title: "Rainbow Connection",artist: "Kermit",genre: "Soundtrack", suggester_id: user.id)

#S
Song.create!(title: "Second Chance",artist: "Shinedown",genre: "Rock", suggester_id: user.id)

#T
Song.create!(title: "Toxic",artist: "Brittany Spears",genre: "Pop", suggester_id: user.id)

#U
Song.create!(title: "Under Pressure",artist: "Queen",genre: "Rock", suggester_id: user.id)

#V
Song.create!(title: "Viva La Vida",artist: "Coldplay",genre: "Douche", suggester_id: user.id)

#W
Song.create!(title: "Wake Up",artist: "Rage Against the Machine",genre: "Alternative", suggester_id: user.id)

#X
Song.create!(title: "Xanadu",artist: "Olivia Newton-John",genre: "Pop", suggester_id: user.id)

#Y
Song.create!(title: "You're a God",artist: "Vertical Horizon",genre: "Pop", suggester_id: user.id)

#Z
Song.create!(title: "Ziggy Stardust",artist: "David Bowie",genre: "Pop", suggester_id: user.id)

#numbers
Song.create!(title: "9 Crimes",artist: "Damien Rice",genre: "Indie", suggester_id: user.id)
Song.create!(title: "867-5309 (Jenny)",artist: "Tommy Tutone",genre: "Oldies", suggester_id: user.id)
Song.create!(title: "(-_-)",artist: "Adebisi Shank",genre: "Math Rock", suggester_id: user.id)

# c = create_playlist
