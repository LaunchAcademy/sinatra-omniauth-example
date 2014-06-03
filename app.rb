require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/flash'
require 'omniauth-github'

require 'dotenv'
Dotenv.load

configure :development do
  require 'pry'
end

configure do
  enable :sessions

  use OmniAuth::Builder do
    provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET']
  end

  set :users, {}
end

helpers do
  def current_user
    uid = session['user_uid']
    settings.users[uid]
  end

  def signed_in?
    !current_user.nil?
  end
end

def authorize!
  unless signed_in?
    flash[:notice] = "You need to sign in first."
    redirect '/'
  end
end

get '/' do
  erb :index
end

get '/secret_page' do
  authorize!

  erb :secret_page
end

get '/auth/github/callback' do
  auth = env['omniauth.auth']
  uid = auth['uid']
  email = auth['info']['email']

  settings.users[uid] = email
  session["user_uid"] = uid

  redirect '/'
end

get '/sign_out' do
  session["user_uid"] = nil
  redirect '/'
end
