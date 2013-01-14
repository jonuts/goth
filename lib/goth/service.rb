module Goth
  class Service
    def initialize(name, scope)
      @name, @scope = name, scope
    end

    attr_reader :scope, :name

    def authorize_url
      client.auth_code.authorize_url(redirect_uri: return_url, scope: scope)
    end

    def client
      Goth.client
    end
    alias_method :consumer, :client

    def return_url
      url = Goth::Config[:return_url]
      Proc === url ? url.call(self) : url
    end

    def generate_token(code)
      client.auth_code.get_token(code, redirect_uri: return_url)
    end
  end
end

