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
        options = args.last.is_a?(Hash) ? args.pop : {}
        options[:host]
        @config = Robinhood::Util::ClientConfig.new options

        @username = args[0]
        @password = args[1]

        if @username.nil? || @password.nil?
          raise ArgumentError, 'Account username and password are required'
        end

        set_up_connection
        set_up_subresources
      end

      protected

      ##
      # Builds up full request path
      # Needs implementation in child classes
      def build_full_path(path, params, method)
        raise NotImplementedError
      end

      ##
      # Set up and cache a Net::HTTP object to use when making requests. This is
      # a private method documented for completeness.
      def set_up_connection # :doc:
        connection_class = Net::HTTP::Proxy @config.proxy_addr,
                                            @config.proxy_port, @config.proxy_user, @config.proxy_pass
        @connection = connection_class.new @config.host, @config.port
        set_up_ssl
        @connection.open_timeout = @config.timeout
        @connection.read_timeout = @config.timeout
      end

      ##
      # Set up the ssl properties of the <tt>@connection</tt> Net::HTTP object.
      # This is a private method documented for completeness.
      def set_up_ssl # :doc:
        @connection.use_ssl = @config.use_ssl
        if @config.ssl_verify_peer
          @connection.verify_mode = OpenSSL::SSL::VERIFY_PEER
          @connection.ca_file = @config.ssl_ca_file
        else
          @connection.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end
      end

      ##
      # Set up sub resources attributes.
      def set_up_subresources # :doc:
        # To be overridden
      end

      ##
      # Send an HTTP request using the cached <tt>@connection</tt> object and
      # return the JSON response body parsed into a hash. Also save the raw
      # Net::HTTP::Request and Net::HTTP::Response objects as
      # <tt>@last_request</tt> and <tt>@last_response</tt> to allow for
      # inspection later.
      def connect_and_send(request) # :doc:
        @last_request = request
        retries_left = @config.retry_limit
        begin
          response = @connection.request request
          @last_response = response
          if response.kind_of? Net::HTTPServerError
            raise Robinhood::REST::ServerError
          end
        rescue
          raise if request.class == Net::HTTP::Post
          if retries_left > 0 then retries_left -= 1; retry else raise end
        end
        if response.body and !response.body.empty?
          object = MultiJson.load response.body
        elsif response.kind_of? Net::HTTPBadRequest
          object = { message: 'Bad request', code: 400 }
        end

        if response.kind_of? Net::HTTPClientError
          raise Robinhood::REST::RequestError.new object['message'], object['code']
        end
        object
      end
    end

    class ServerError < StandardError; end

    class RequestError < StandardError
      attr_reader :code

      def initialize(message, code=nil);
        super message
        @code = code
      end
    end
  end
end
