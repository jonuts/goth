module Goth
  class OAuth2 < Client
    class <<self
      def client
        @client = ::OAuth2::Client.new(Config[:oauth2_client_id], Config[:oauth2_client_secret], {
          site: 'https://accounts.google.com',
          authorize_url: '/o/oauth2/auth',
          token_url: '/o/oauth2/token'
        })
      end

      def generate_token(code, service)
        client.auth_code.get_token(code, redirect_uri: service.return_url)
      end

      def authorize_url(service)
        client.auth_code.authorize_url({redirect_uri: service.return_url, scope: service.scope}.merge(service.opts))
      end
    end
  end
end

