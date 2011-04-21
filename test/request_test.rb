require "test/unit"
require "rack/mock"
require File.expand_path(File.join(File.dirname(__FILE__), *%w[.. lib rack_scheme_detect]))

class RequestTest < Test::Unit::TestCase
  def test_checks_x_forwarded_ssl_header
    r = Rack::Request.new(Rack::MockRequest.env_for("/", 'HTTP_X_FORWARDED_SSL' => 'on'))
    assert r.ssl?
  end
  
  def test_add_additional_checks
    Rack::Request.add_scheme_mapping("https") do |env|
      env['HTTP_USWITCH_HTTPS'] == "on"
    end
    
    r = Rack::Request.new(Rack::MockRequest.env_for("/", 'HTTP_USWITCH_HTTPS' => 'on'))
    assert r.ssl?    
  end
end