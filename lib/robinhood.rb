require 'singleton'
require "robinhood/version"

module Robinhood
  module Util
    class ClientConfig
      DEFAULTS = {
        host: 'api.robinhood.com',
        port: 443,
        use_ssl: true,
        ssl_verify_peer: false,
        timeout: 30,
        proxy_addr: nil,
        proxy_port: nil,
        proxy_user: nil,
        proxy_pass: nil,
        retry_limit: 1
      }

      DEFAULTS.each_key do |attribute|
        attr_accessor attribute
      end

      def initialize(opts={})
        DEFAULTS.each do |attribute, value|
          send("#{attribute}=".to_sym, opts.fetch(attribute, value))
        end
      end
    end
  end
  module REST
    class Client
      def initialize(*args)

        if @username.nil? || @password.nil?
          raise ArgumentError, 'Account username and password are required'
        end
      end
    end
  end
end
