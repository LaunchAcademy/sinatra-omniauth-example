require 'dotenv'
Dotenv.load

require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/flash'
require 'omniauth-github'
require 'omniauth-facebook'

require_relative 'models/user'

configure :development do
  require 'pry'
end

configure do
  enable :sessions

  use OmniAuth::Builder do
    provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET']
    provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET']
  end
end


def authorize!
  unless signed_in?
    flash[:notice] = "You need to sign in first."
    redirect '/'
  end
end

helpers do
  def current_user
    id = session['user_id']
    @current_user ||= User.find_by_id(id)
  end

  def signed_in?
    !current_user.nil?
  end
end

get '/' do
  erb :index
end

get '/secret_page' do
  authorize!

  erb :secret_page
end

get '/auth/:provider/callback' do
  # This is returns a hash with all of the information sent back by the
  # service (Github or Facebook)
  auth = env['omniauth.auth']

  # Build a hash that represents the user from the info given back from either
  # Facebook or Github
  user_attributes = {
    uid: auth['uid'],
    provider: auth['provider'],
    email: auth['info']['email'],
    avatar_url: auth['info']['image']
  }

  user = User.create(user_attributes)

  # Save the id of the user that's logged in inside the session
  session["user_id"] = user.id

  redirect '/'
end

get '/sign_out' do
  # Sign the user out by removing the id from the session
  session["user_id"] = nil
  redirect '/'
end
