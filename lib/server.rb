require 'sinatra'
require_relative 'pl.rb'

set :bind, '0.0.0.0'

get '/' do
  erb :login
end

post '/' do
  erb :homepage
end

get '/signup' do
  erb :signup
end

post '/signup' do
  @username = params[:username]
  @password = params[:password]
  result = PL::CreateUser.run(username: @username, password: @password)
 # check if user exists
  unless result.success?
    @fail_message = result.error.to_s.gsub("_", " ")
    erb :signup_fail
  else
    erb :signup_success
    # posts success message here
    # creates button to complete login, redirects to homepage with session active
  end
end
