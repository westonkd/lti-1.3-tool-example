# lti-1.3-tool-example

This is an LTI 1.3 tool I use to experiment with new ideas I have around LTI Advantage.

It's lightweight, simplistic, and *not* a shell for a production-ready tool. It can, however, serve as a useful resource while learning LTI 1.3

If you are getting started with LTI 1.3 and want to learn the basics, `web/app.rb` may be a useful demonstration of the official specs:
- http://www.imsglobal.org/spec/security/v1p0/#openid_connect_launch_flow
- http://www.imsglobal.org/spec/lti/v1p3/

## Running Locally
This tool uses Docker and Docker Compose.

1. Copy `docker-compose-copy.override.example.yml` to `docker-compose-copy.override.yml` and modify it to meet your needs
2. Change values in `web/config.yml` to match your platform and they client ID they issued the tool
3. `docker-compose build`
4. `docker-compose up`

For instructions on installing an LTI 1.3 tool in your chosen platform, please refer to that platform's documentation.

Directions for installing in Canvas LMS can be found at https://canvas.instructure.com/doc/api/file.lti_dev_key_config.html

## Configuration
**Redirect URI:** http://example-tool.docker/launch

**OpenID Connect Initiation Url:** http://example-tool.docker/login

**Public JWK URL:** http://example-tool.docker/public_key

## Notes
* Because I use this tool to experiment with new LTI Advantage ideas, some features are not part of any LTI Advantage specification. These portions of code have been marked with an `@experimental` annotation.
