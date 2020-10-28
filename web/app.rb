require 'sinatra'
require "sinatra/config_file"
require "sinatra/json"
require "json/jwt"

configure { set :server, :puma }
config_file 'config.yml'

set :root, 'web/app'

# Allow embedding in an iframe
set :protection, except: :frame_options

# Routes
get '/' do
  erb :index, locals: { bundle: '/bundle.js' }
end

post '/login' do
  erb :login, locals: {
    bundle: '/login.js',
    authentication_endpoint: settings.authentication_endpoint,
    client_id: settings.client_id,
    redirect_uri: "#{request.base_url}/launch",
    login_hint: params[:login_hint],
    lti_message_hint: params[:lti_message_hint],
    state: SecureRandom.uuid,
    nonce: SecureRandom.uuid
  }
end

post '/launch' do
  erb :launch, locals: { bundle: '/launch.js' }
end

# In a real app, this endpoint would need to be
# behind authentication to make sure the app's
# front-end is the only thing that can access
# it.
post '/decrypt' do
  request.body.rewind
  parsed_body = JSON.parse request.body.read

  private_key = JSON::JWK.new(settings.keys['private'])
  jwe = JSON::JWT.decode(parsed_body['token'], private_key)
  jwe.decrypt! private_key

  json token: JSON::JWT.decode(jwe.plain_text)
end

get '/test' do
  SecureRandom.uuid
end
