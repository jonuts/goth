lib = File.expand_path('..', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'oauth'
require 'oauth/consumer'
require 'oauth/signature/rsa/sha1'

require 'goth/config'
require 'goth/service'
require 'goth/version'

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

  register_service :analytics, "https://www.google.com/analytics/feeds"
  register_service :webmasters, "https://www.google.com/webmasters/tools/feeds"
end

