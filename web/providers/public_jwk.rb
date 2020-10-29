require 'httparty'

module Providers
  class PublicJwk
    def self.fetch_jwks(url)
      response = HTTParty.get(url)
      return nil unless response.success?

      JSON::JWK::Set.new(JSON.parse(response.body))
    end
  end
end