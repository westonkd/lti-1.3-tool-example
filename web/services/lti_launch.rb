module Services
  class LtiLaunch
    attr_reader :validation_errors

    def initialize(id_token, publc_jwk_url, expected_aud)
      # Decrypt the token and verify its signature
      # is valid by using the platforms public key
      # set.
      @decoded_jwt = JSON::JWT.decode(
        id_token,
        Providers::PublicJwk.fetch_jwks(publc_jwk_url)
      )

      @expected_aud = expected_aud
      @validation_errors = []
    end

    def valid?
      validate!
      @validation_errors.length == 0
    end

    def [](key)
      @decoded_jwt[key]
    end

    private

    def validate!
      # Do standard JWT validation
      validators = %i[validate_aud validate_azp validate_sub validate_iat validate_exp validate_nonce]

      validators.each { |v| send(v) }
    end

    def validate_aud
      # Make sure that the "aud" (audience) claim matches
      # what we expect. The "aud" should always be (or include)
      # The tool's client ID
      @validation_errors << 'the expected "aud" is missing' unless Array(@decoded_jwt['aud']).include? @expected_aud.to_s
    end

    def validate_azp
      # The "azp" (authorized party) should include the
      # expected audience
      @validation_errors << 'invalid "azp"' unless Array(@decoded_jwt['azp']).include? @decoded_jwt['aud']
    end

    def validate_sub
      # The "sub" (subject) claim in the ID of the launching user.
      # Just make sure it is present
      iss = @decoded_jwt['iss']
      @validation_errors << '"iss" is blank' if iss.nil? || iss.blank?
    end

    def validate_iat
      # Make sure that the "iat" (issued at) is not too old
      @validation_errors << '"iat" must be less than 10 minutes old' if Time.now - Time.at(@decoded_jwt['iat']) > 600
    end

    def validate_exp
      # Make sure the "exp" (expiration) has not passed. It's typically good
      # in include a buffer to account for any clock drift
      buffer = 30
      @validation_errors << 'the "exp" is in the past' if (Time.at(@decoded_jwt['exp']) - 30) < Time.now
    end

    def validate_nonce
      # This example tool does not do nonce validation to keep things simple.
      # Actualy production tools should actually veirfy nonces are not reused
      # within a given time period to mitigate replay attacks.
      true
    end

  end
end