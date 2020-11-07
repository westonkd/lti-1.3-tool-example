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

get '/public_key' do
  public_key = JSON::JWK.new(settings.keys['public'])
  json public_key
end

# POST login
# http://www.imsglobal.org/spec/security/v1p0/#step-1-third-party-initiated-login
#
# The first leg of the LTI 1.3 launch is a post request from the
# tool provider to this endpoint
#
# The tool responds to this endpoint by kicking off the second leg
# of the LTI 1.3 launch: the authentication request (See
# http://www.imsglobal.org/spec/security/v1p0/#step-2-authentication-request)
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

# POST launch
# http://www.imsglobal.org/spec/security/v1p0/#step-3-authentication-response
#
# The final leg of the LTI 1.3 launch, the authentication response,
# is made by the platform to this endpoint.
post '/launch' do
  # Is the LTI launch valid? See Services::LtiLaunch
  # For validation details.
  #
  # Note that this validator does not check the integrity
  # "state" parameter. A real production tool should do so
  @lti_launch = Services::LtiLaunch.new(
    params[:id_token],
    settings.public_jwks_endpoint,
    settings.client_id
  )

  halt 401 unless @lti_launch.valid?

  erb :launch, locals: { bundle: '/launch.js' }
end

# POST decrypt
# @experimental
#
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
