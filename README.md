# lti-1.3-tool-example

This is an LTI 1.3 tool I use to experiment with new ideas I have around LTI Advantage.

It's lightweight, simplistic, and *not* a shell for a production-ready tool. It can, however, serve as a useful resource while learning LTI 1.3

If you are getting started with LTI 1.3 and want to learn the basics, `web/app.rb` may be a useful demonstration of the official specs:
- http://www.imsglobal.org/spec/security/v1p0/#openid_connect_launch_flow
- http://www.imsglobal.org/spec/lti/v1p3/

## Running Locally
This tool uses Docker and Docker Compose.

1. Copy `docker-compose-copy.override.example.yml` to `docker-compose-copy.override.yml` and modify it to meet your needs
2. `docker-compose build`
3. `docker-compose up`