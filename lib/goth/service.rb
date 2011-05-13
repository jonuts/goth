module Goth
  class Service
    def initialize(name, scope)
      @name, @scope = name, scope
    end

    attr_reader :scope, :name

    def get_request_token
      consumer.get_request_token({:oauth_callback => return_url}, {:scope => scope})
    end

    def consumer
      Goth.consumer
    end

    def return_url
      url = Goth::Config[:return_url]
      Proc === url ? url.call(self) : url
    end
  end
end

