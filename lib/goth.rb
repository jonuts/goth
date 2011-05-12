require 'oauth/consumer'
require 'oauth/signature/rsa/sha1'

module Goth
  class << self
    def consumer
      @consumer ||= OAuth::Consumer.new(Config[:consumer_key], Config[:consumer_secret], {
        :site               => 'https://www.google.com',
        :request_token_path => '/accounts/OAuthGetRequestToken',
        :access_token_path  => '/accounts/OAuthGetAccessToken',
        :authorize_path     => '/accounts/OAuthAuthorizeToken',
        :signature_method   => "HMAC-SHA1"
      })
    end

    # Regenerate a request token from OAuth::RequestToke#token and OAuthRequestToken#secret
    def generate_request_token(token, secret)
      OAuth::RequestToken.new(consumer, token, secret)
    end

    def generate_access_token(token, secret)
      OAuth::AccessToken.new(consumer, token, secret)
    end

    def registered_services
      services.keys
    end

    def register_service(name, scope)
      services[name] = Service.new(name, scope) unless services[name]
    end

    def [](name)
      services[name]
    end

    private

    def services
      @services ||= Hash.new(false)
    end
  end

  class Config
    OPTS = [:consumer_key, :consumer_secret, :return_url] unless
      self.const_defined?(:OPTS)

    class << self
      def [](c)
        assert_valid_opt!(c)
        opts[c]
      end

      def []=(c,v)
        assert_valid_opt!(c)
        opts[c] = v
      end

      def use
        yield opts
      end

      private

      def assert_valid_opt!(c)
        raise ArgumentError, "`#{c}' is not a valid option" unless 
          OPTS.member?(c)
      end

      def opts 
        @__opts__ ||= Struct.new(*OPTS)
      end
    end
  end

  class Service
    def initialize(name, scope)
      @name, @scope = name, scope
    end

    attr_reader :scope

    def get_request_token
      consumer.get_request_token({:oauth_callback => Goth::Config[:return_url]}, {:scope => scope})
    end

    def consumer
      Goth.consumer
    end
  end

  register_service :analytics, "https://www.google.com/analytics/feeds"
  register_service :webmasters, "https://www.google.com/webmasters/tools/feeds"
end

