post "/:user/:song/:vote"
  if params[:user] == user.id && params[:song] == song.id
    if params[:vote] == up
      vote_val = 1
    else
      vote_val = -1
    end
    Vote.create!(user: user.id, song: song.id, :vote: vote_val placed_at: Date.time)
  else
    status 404
  end
end
