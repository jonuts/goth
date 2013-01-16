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
    def client
      @client ||= OAuth2::Client.new(Config[:client_id], Config[:client_secret], {
        site: 'https://accounts.google.com',
        authorize_url: '/o/oauth2/auth',
        token_url: '/o/oauth2/token'
      })
    end
    alias_method :consumer, :client

    def generate_token(code, service)
      services[service.to_sym].generate_token(code)
    end

    def registered_services
      services.keys
    end

    def register_service(name, scope, opts={})
      services[name] = Service.new(name, scope, opts) unless services[name]
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
  register_service :adwords, "https://adwords.google.com/api/adwords", {access_type: 'offline', approval_prompt: 'force'}
end

