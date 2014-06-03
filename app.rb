require 'sinatra'
require 'sinatra/reloader'

get '/' do
  erb :index
end

get '/secret_page' do
  erb :secret_page
end
