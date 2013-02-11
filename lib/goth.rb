lib = File.expand_path('..', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'oauth'
require 'oauth/consumer'
require 'oauth/signature/rsa/sha1'

require 'goth/config'
require "goth/client"
require "goth/oauth"
require "goth/oauth2"
require 'goth/service'
require 'goth/version'

module Goth
  class << self
    def registered_services
      services.keys
    end

    def register_service(client, name, scope, opts={})
      klass = ::Goth.const_get(client)
      service = Service.new(name, scope, opts.merge(oauth: klass))
      services[name] = klass.services[name] = service unless services[name]
    end

    def [](name)
      services[name]
    end

    private

    def services
      @services ||= Hash.new(false)
    end
  end

  register_service :OAuth, :analytics, "https://www.google.com/analytics/feeds"
  register_service :OAuth, :webmasters, "https://www.google.com/webmasters/tools/feeds"
  register_service :OAuth2, :adwords, "https://adwords.google.com/api/adwords", {access_type: 'offline', approval_prompt: 'force'}
end

