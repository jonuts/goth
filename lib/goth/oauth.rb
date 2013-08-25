module Goth
  class OAuth < Client
    class <<self
      def consumer
        ::OAuth::Consumer.new(Config[:oauth_consumer_key], Config[:oauth_consumer_secret], {
          site:               'https://www.google.com',
          request_token_path: '/accounts/OAuthGetRequestToken',
          access_token_path:  '/accounts/OAuthGetAccessToken',
          authorize_path:     '/accounts/OAuthAuthorizeToken',
          signature_method:   "HMAC-SHA1",
          timeout:            360
        })
      end

      def generate_request_token(token, secret)
        ::OAuth::RequestToken.new(consumer, token, secret)
      end

      def generate_access_token(token, secret)
        ::OAuth::AccessToken.new(consumer, token, secret)
      end

      def get_request_token(service)
        consumer.get_request_token({oauth_callback: service.return_url}, {scope: service.scope})
      end
    end
  end
end

