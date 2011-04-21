# Rack Scheme Detect
Allows Rack applications to define additional matchers for HTTP header matching to indicate URL scheme. For example, this can be used when load balancers set non-standard headers to indicate whether a request is SSL secured.

## Usage

Somewhere in your application you can add a scheme mapping to the Rack::Request class. It will return the scheme passed as a param, if the block returns true. For example, to trigger `https` when the `HTTP_USWITCH_HTTPS` header is set to `on`.

    Rack::Request.add_scheme_mapping("https") do |env|
      env['HTTP_USWITCH_HTTPS'] == "on"
    end

## Copyright
Copyright &copy; Paul Ingles 2011.