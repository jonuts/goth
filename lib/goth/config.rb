module Goth
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
        @__opts__ ||= Struct.new(*OPTS).new
      end
    end
  end
end

