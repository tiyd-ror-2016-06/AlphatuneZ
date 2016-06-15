class Protected < Sinatra::Base

  use Rack::Auth::Basic, "Protected Area" do |username, password|
    username == 'foo' && password == 'bar'
  end

  get '/dashboard' do
    "need login"
  end

  get '/user/song/vote' do
    "need login"
  end

  get '/account' do
    "need login"
  end

  get '/api/me'
    "need login"
  end

  get '/songs'
    "need login"
  end



end

class Public < Sinatra::Base

  get '/newuser' do
    "public"
  end

  get '/' do
    "public"
  end

end
