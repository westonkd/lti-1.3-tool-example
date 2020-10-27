require 'sinatra'
require "sinatra/reloader" if development?

configure { set :server, :puma }

set :root, 'web/app'

get '/' do
  render :html, :index
end

get '/login' do
  "hello! dogs"
end