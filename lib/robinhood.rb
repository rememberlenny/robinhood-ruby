require 'singleton'
require "robinhood/version"

module Robinhood
  module Util
    class ClientConfig
      def initialize(*args)
        
      end
    end
  end
  module REST
    class Client
      def initialize(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        options[:host] ||= self.class.host
        @config = Twilio::Util::ClientConfig.new options

        if @username.nil? || @password.nil?
          raise ArgumentError, 'Account username and password are required'
        end
      end
    end
  end
end
