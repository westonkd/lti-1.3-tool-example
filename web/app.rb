require 'sinatra'
require "sinatra/reloader" if development?

configure { set :server, :puma }

set :root, 'web/app'

get '/' do
  erb :index, locals: { bundle: '/bundle.js' }
end

get '/login' do
  erb :login, locals: {
    bundle: '',
    authentication_endpoint: 'https://www.test.com',
    client_id: 100000005,
    redirect_uri: 'https://www.test.com',
    login_hint: 'login hinht',
    state: 'state',
    nonce: 'nonce'
  }
end
