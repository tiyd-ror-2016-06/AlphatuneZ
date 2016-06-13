
HTTParty.get "https://api.spotify.com/v1/search?q=Fireflies&type=track", headers: { "Accept" => "application/json", "Authorization" => "Bearer #{Token}" }

list_of_songs = []

# Some song Details

songs.each do |s|
list_of_songs.push(s)
songs.first["album"]["name"]



e = JSON.parse(File.read "spotifytest1")


raw_songs = []
rawdata["tracks"]["items"].each do |f|
raw_songs.push(f)
end


songs.each do |s|
  song_hash = {}
  s.keys.each do |key|
    case key
    when "album"
      song_hash[key] = s[key]["name"]
    when "artists"
      song_hash["artist"] = s[key]["name"]
    when "id"
      song_hash["id"] = s[key]["id"]
    when "name"
      song_hash["title"] = s[key]["name"]
    end
  end
