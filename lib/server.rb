require 'sinatra'
require 'pry-debugger'
require 'digest/md5'

require_relative 'pl.rb'

set :bind, '0.0.0.0'

enable :sessions

get '/' do
  if session[:logged_in] == true
    @playlists = PL::ShowPlaylists.run(username: session[:username]).playlists
    erb :homepage, :layout => :layout_logged_in
  else
    erb :login
  end
end

post '/' do
  @username = params[:username]
  @password = params[:password]
  result = PL::LogInUser.run(name: @username, password: @password)
  unless result.success?
    @fail_message = result.error.to_s.gsub("_", " ")
    erb :login
  else
    session[:logged_in] = true
    session[:username] = @username
    session[:password] = @password
    session[:gravatar] = gravatar_url_for(@username, 48)
    session[:user_handle] = get_handle_from_email(@username)
    @playlists = PL::ShowPlaylists.run(username: @username).playlists
    # binding.pry
    erb :homepage, :layout => :layout_logged_in
  end
end

get '/create_playlist' do
  erb :create_playlist, :layout => :layout_logged_in
end

post '/create_playlist' do
  PL::CreatePlaylist.run(username: session[:username], name: params[:new_playlist])
  redirect to('/')
end

get '/playlist/:id' do
  @playlist_id = params[:id]
  @playlist = PL::ModifyPlaylist.get(id: @playlist_id).playlist
  @songs = PL::GetPlaylistSongs.run(playlist_id: params[:id]).songs
  erb :playlist_songs, :layout => :layout_logged_in
end

get '/playlist/:id/edit' do
  @playlist_id = params[:id]
  @playlist = PL::ModifyPlaylist.get(id: @playlist_id).playlist
  erb :edit_playlist, :layout => :layout_logged_in
end

post '/playlist/:id/edit' do
  @playlist_id = params[:id]
  @playlist = PL::ModifyPlaylist.edit(username: session[:username], id: @playlist_id, name: params[:name]).playlist
  redirect to('/')
end

get '/playlist/:id/delete' do
  @playlist_id = params[:id]
  @playlist = PL::ModifyPlaylist.get(id: @playlist_id.to_i).playlist
  erb :delete_playlist, :layout => :layout_logged_in
end

post '/playlist/:id/delete' do
  @playlist_id = params[:id]
  @playlist = PL::ModifyPlaylist.delete(username: session[:username], id: @playlist_id.to_i)
  redirect to('/')
end

get '/playlist/:id/add_song' do
  @playlist_id = params[:id]
  erb :add_song, :layout => :layout_logged_in
end

post '/playlist/:id/add_song' do
  @playlist_id = params[:id]
  PL::SongCommand.add(name: params[:song_title], artist: params[:artist], playlist_id: @playlist_id, url: params[:url])
  redirect to("playlist/#{@playlist_id}")
end

get '/playlist/:id/edit_song/:song_id' do
  @playlist_id = params[:id]
  @song = PL::SongCommand.get(id: params[:song_id].to_i).song
  erb :edit_song, :layout => :layout_logged_in
end

post '/playlist/:id/edit_song/:song_id' do
  @playlist_id = params[:id]
  PL::SongCommand.edit(id: params[:song_id], name: params[:song_title], artist: params[:artist], playlist_id: @playlist_id, url: params[:url])
  redirect to("playlist/#{@playlist_id}")
end

get '/playlist/:id/delete_song/:song_id' do
  @playlist_id = params[:id]
  @song = PL::SongCommand.get(id: params[:song_id].to_i).song
  erb :delete_song, :layout => :layout_logged_in
end

post '/playlist/:id/delete_song/:song_id' do
  @playlist_id = params[:id]
  PL::SongCommand.delete(id: params[:song_id].to_i)
  redirect to("playlist/#{@playlist_id}")
end

get '/signup' do
  erb :signup
end

post '/signup' do
  @username = params[:username]
  @password = params[:password]
  result = PL::CreateUser.run(name: @username, password: @password)
  # binding.pry
 # check if user exists
  unless result.success?
    @fail_message = result.error.to_s.gsub("_", " ")
    erb :signup_fail
  else
    session[:logged_in] = true
    session[:username] = @username
    session[:password] = @password
    erb :signup_success
    # posts success message here
    # creates button to complete login, redirects to homepage with session active
  end
end


get '/logout' do
  session.clear
  redirect to('/')
end

def gravatar_url_for(email, size=48)
  # binding.pry
  hash = Digest::MD5.hexdigest(email)
  "http://gravatar.com/avatar/#{hash}?s=#{size}"
end

def get_handle_from_email(email)
  /[^@]+/.match(email).to_s
end