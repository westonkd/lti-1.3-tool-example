require 'sinatra'
require 'sinatra/config_file'
require 'sinatra/json'
require 'json/jwt'

require_relative 'services'
require_relative 'providers'

configure { set :server, :puma }
config_file 'config.yml'

set :root, 'web/app'

# Allow embedding in an iframe
set :protection, except: :frame_options

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
  # Is the LTI launch valid? See Services::LtiLaunch
  # For validation details.
  #
  # Note that this validator does not check the
  # "state" parameter.
  lti_launch = Services::LtiLaunch.new(
    params[:id_token],
    settings.public_jwks_endpoint,
    settings.client_id
  )

  halt 401 unless lti_launch.valid?

  erb :launch, locals: { bundle: '/launch.js' }
end

# In a real app, this endpoint would need to be
# behind authentication to make sure the app's
# front-end is the only thing that can access
# it.
#
# @experimental
post '/decrypt' do
  request.body.rewind
  parsed_body = JSON.parse request.body.read

  private_key = JSON::JWK.new(settings.keys['private'])
  jwe = JSON::JWT.decode(parsed_body['token'], private_key)
  jwe.decrypt! private_key

  json token: JSON::JWT.decode(jwe.plain_text)
end
