module Goth
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
end

