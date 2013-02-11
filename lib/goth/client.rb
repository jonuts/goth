module Goth
  class Client
    class <<self
      def inherited(klass)
        clients << klass
      end

      def services
        @services ||= Hash.new(false)
      end

      def [](name)
        services[name]
      end

      private

      def clients
        @clients ||= []
      end
    end
  end
end

