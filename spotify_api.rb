


songs.each do |s|
  song_hash = {}
  s.keys.each do |key|
    case key
    when "album"
      #song_hash[key] = s[key]["name"]
    when "artists"
      song_hash["artist"] = s[key]["name"]
    when "id"
      song_hash["id"] = s[key]["id"]
    when "name"
      song_hash["title"] = s[key]["name"]
    end
  end
end
