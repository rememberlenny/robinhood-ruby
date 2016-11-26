module Robinhood
  module REST
    class BaseClient
      include Robinhood::Util
      include Robinhood::REST::Utils

      HTTP_HEADERS = {
        'Accept' => '*/*',
        'Accept-Encoding' => 'gzip, deflate',
        'Accept-Language' => 'en;q=1, fr;q=0.9, de;q=0.8, ja;q=0.7, nl;q=0.6, it;q=0.5',
        'Content-Type' => 'application/x-www-form-urlencoded; charset=utf-8',
        'X-Robinhood-API-Version' => '1.0.0',
        'Connection' => 'keep-alive',
        'User-Agent' => 'Robinhood/823 (iPhone; iOS 7.1.2; Scale/2.00)'
      }

      ##
      # Override the default host for a REST Client (api.twilio.com)
      def self.host(host=nil)
        return @host unless host
        @host = host
      end

      attr_reader :username, :last_request, :last_response

      def initialize(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        options[:host]
        @config = Robinhood::Util::ClientConfig.new options

        @username = args[0] || Robinhood.username
        @password = args[1] || Robinhood.password
        @username = (args.size > 2 && args[2].is_a?(String) ? args[2] : args[0]) || Robinhood.username

        if @username.nil? || @password.nil?
          raise ArgumentError, 'Account username and password are required'
        end

        set_up_connection
        set_up_subresources
      end

      ##
      # Define #get, #put, #post and #delete helper methods for sending HTTP
      # requests to Robinhood. You shouldn't need to use these methods directly,
      # but they can be useful for debugging. Each method returns a hash
      # obtained from parsing the JSON object in the response body.
      [:get, :put, :post, :delete].each do |method|
        method_class = Net::HTTP.const_get method.to_s.capitalize
        define_method method do |path, *args|
          params = robinify(args[0])
          params = {} if params.empty?
          # build the full path unless already given
          path = build_full_path(path, params, method) unless args[1]
          request = method_class.new(path, HTTP_HEADERS)
          request.basic_auth(@username, @password)
          request.form_data = params if [:post, :put].include?(method)
          connect_and_send(request)
        end
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
  end
end