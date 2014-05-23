require 'sinatra'
require 'pry-debugger'
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
    @playlists = PL::ShowPlaylists.run(username: @username).playlists
    binding.pry
    erb :homepage, :layout => :layout_logged_in
  end
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

get '/create_playlist' do
  erb :create_playlist
end

post '/create_playlist' do
  PL::CreatePlaylist.run(username: session[:username], name: params[:new_playlist])
  redirect to('/')
end

get '/logout' do
  session.clear
  redirect to('/')
end
