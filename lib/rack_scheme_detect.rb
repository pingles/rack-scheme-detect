module Rack
  class Request
    class SchemeMatcher
      attr_reader :scheme
      
      def initialize(scheme, &block)
        @scheme = scheme
        @block = block
      end
      
      def matches?(env)
        return @scheme if @block.call(env)
      end
    end
    
    def ssl?
      scheme == "https"
    end

    if respond_to?(:scheme)
      alias_method :old_scheme, :scheme
    end
    
    def scheme
      matcher = Request.scheme_mappings.detect {|m| m.matches?(env) }
      return matcher.scheme if matcher
      
      return 'https' if env['HTTPS'] == 'on'
      return 'https' if env['HTTP_X_FORWARDED_SSL'] == 'on'
      return env['HTTP_X_FORWARDED_PROTO'].split(',')[0] if env['HTTP_X_FORWARDED_PROTO']
    
      old_scheme if respond_to?(:old_scheme)
    end
    
    class << self
      def add_scheme_mapping(scheme, &block)
        scheme_mappings << SchemeMatcher.new(scheme, &block)
      end
      
      def scheme_mappings
        @mappings ||= []
      end
    end
  end
end
