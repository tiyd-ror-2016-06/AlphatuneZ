require "./db/setup"
require "./lib/all"
require "./lib/time"

# Use ARGV[0] to change week of playlist e.g. current week - n weeks

def random_no
  rand(5000)
end

def week
  week_number = (ARGV[0] ||= "0").to_i
  value = Time.at (week_number * 7).days.ago
end

#[User, Song].each { |klass| klass.delete_all }

user = User.find_by(email: "fake@compuserve.com")

#A
Song.create!(title: "Absolutely (Story of a Girl)",artist: "Nine Days",genre: "Pop", suggester_id: user.id, spotify_id: random_no.to_s, suggested_date: week)
Song.create!(title: "Always",artist: "Saliva",genre: "Alternative", suggester_id: user.id, spotify_id: random_no.to_s, suggested_date: week)

#B
Song.create!(title: "Baby Got Back",artist: "Sir Mix-A-Lot",genre: "Rap", suggester_id: user.id, spotify_id: random_no.to_s, suggested_date: week)

#C
Song.create!(title: "C.R.E.A.M.",artist: "Wu-Tang Clan",genre: "Rap", suggester_id: user.id, spotify_id: random_no.to_s, suggested_date: week)

#D
Song.create!(title: "Dead",artist: "My Chemical Romance",genre: "Emo", suggester_id: user.id, spotify_id: random_no.to_s, suggested_date: week)
Song.create!(title: "Devil Went Down to Georgia",artist: "The Charlie Daniels Band",genre: "Country", suggester_id: user.id, spotify_id: random_no.to_s, suggested_date: week)

#E
Song.create!(title: "Empire State Of Mind",artist: "Jay-Z",genre: "Rap", suggester_id: user.id, spotify_id: random_no.to_s, suggested_date: week)
Song.create!(title: "(Everything I Do) I Do It For You",artist: "Bryan Adams",genre: "Soundtrack", suggester_id: user.id, spotify_id: random_no.to_s, suggested_date: week)

#F
Song.create!(title: "Fancy",artist: "Iggy Azalea",genre: "Pop", suggester_id: user.id, spotify_id: random_no.to_s, suggested_date: week)

#G
Song.create!(title: "Gonna Get Over You",artist: "Sara Bareilles",genre: "Pop", suggester_id: user.id, spotify_id: random_no.to_s, suggested_date: week)

#H
Song.create!(title: "Halleluja",artist: "Rufus Wainwright",genre: "Indie", suggester_id: user.id, spotify_id: random_no.to_s, suggested_date: week)

#I
Song.create!(title: "Ice Cream Paint Job",artist: "Dorrough Music",genre: "Rap", suggester_id: user.id, spotify_id: random_no.to_s, suggested_date: week)

#J
Song.create!(title: "Julia",artist: "Horror Pops",genre: "Alternative", suggester_id: user.id, spotify_id: random_no.to_s, suggested_date: week)

#K
Song.create!(title: "Karma Chameleon",artist: "Culture Club",genre: "Techno", suggester_id: user.id, spotify_id: random_no.to_s, suggested_date: week)

#L
Song.create!(title: "Love Story",artist: "Taylor Swift",genre: "Pop", suggester_id: user.id, spotify_id: random_no.to_s, suggested_date: week)

#M
Song.create!(title: "Monkey Wrench",artist: "Foo Fighters",genre: "Punk", suggester_id: user.id, spotify_id: random_no.to_s, suggested_date: week)

#N
Song.create!(title: "Naturally",artist: "Selena Gomez",genre: "Pop", suggester_id: user.id, spotify_id: random_no.to_s, suggested_date: week)

#O
Song.create!(title: "Outkast",artist: "P.O.D.",genre: "Alternative", suggester_id: user.id, spotify_id: random_no.to_s, suggested_date: week)

#P
Song.create!(title: "Phantom Of The Opera",artist: "Me First and the Gimmie-gimmies",genre: "Alternative", suggester_id: user.id, spotify_id: random_no.to_s, suggested_date: week)

#Q
Song.create!(title: "Queen Bitch",artist: "David Bowie",genre: "Pop", suggester_id: user.id, spotify_id: random_no.to_s, suggested_date: week)

#R
Song.create!(title: "Rainbow Connection",artist: "Kermit",genre: "Soundtrack", suggester_id: user.id, spotify_id: random_no.to_s, suggested_date: week)

#S
Song.create!(title: "Second Chance",artist: "Shinedown",genre: "Rock", suggester_id: user.id, spotify_id: random_no.to_s, suggested_date: week)

#T
Song.create!(title: "Toxic",artist: "Brittany Spears",genre: "Pop", suggester_id: user.id, spotify_id: random_no.to_s, suggested_date: week)

#U
Song.create!(title: "Under Pressure",artist: "Queen",genre: "Rock", suggester_id: user.id, spotify_id: random_no.to_s, suggested_date: week)

#V
Song.create!(title: "Viva La Vida",artist: "Coldplay",genre: "Douche", suggester_id: user.id, spotify_id: random_no.to_s, suggested_date: week)

#W
Song.create!(title: "Wake Up",artist: "Rage Against the Machine",genre: "Alternative", suggester_id: user.id, spotify_id: random_no.to_s, suggested_date: week)

#X
Song.create!(title: "Xanadu",artist: "Olivia Newton-John",genre: "Pop", suggester_id: user.id, spotify_id: random_no.to_s, suggested_date: week)

#Y
Song.create!(title: "You're a God",artist: "Vertical Horizon",genre: "Pop", suggester_id: user.id, spotify_id: random_no.to_s, suggested_date: week)

#Z
Song.create!(title: "Ziggy Stardust",artist: "David Bowie",genre: "Pop", suggester_id: user.id, spotify_id: random_no.to_s, suggested_date: week)

#numbers
Song.create!(title: "9 Crimes",artist: "Damien Rice",genre: "Indie", suggester_id: user.id, spotify_id: random_no.to_s, suggested_date: week)
Song.create!(title: "867-5309 (Jenny)",artist: "Tommy Tutone",genre: "Oldies", suggester_id: user.id, spotify_id: random_no.to_s, suggested_date: week)
Song.create!(title: "(-_-)",artist: "Adebisi Shank",genre: "Math Rock", suggester_id: user.id, spotify_id: random_no.to_s, suggested_date: week)
