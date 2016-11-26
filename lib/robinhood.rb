require 'singleton'
require "robinhood/version"

module Robinhood
  module Util
    def url_encode(hash)
      hash.to_a.map {|p| p.map {|e| CGI.escape get_string(e)}.join '='}.join '&'
    end

    def get_string(obj)
      if obj.respond_to?(:strftime)
        obj.strftime('%Y-%m-%d')
      else
        obj.to_s
      end
    end
  end
end

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
end

module Robinhood
  module REST
    class Client < BaseClient
      API_VERSION = ""
      attr_reader :account, :accounts

      host 'api.robinhood.com'
      

      def initialize(*args)
        super(*args)
      end

      def inspect # :nodoc:
        "<Robinhood::REST::Client @account_sid=#{@account_sid}>"
      end

      ##
      # Delegate account methods from the client. This saves having to call
      # <tt>client.account</tt> every time for resources on the default
      # account.
      def method_missing(method_name, *args, &block)
        if account.respond_to?(method_name)
          account.send(method_name, *args, &block)
        else
          super
        end
      end

      def respond_to?(method_name, include_private=false)
        if account.respond_to?(method_name, include_private)
          true
        else
          super
        end
      end

      protected

      ##
      # Set up +account+ and +accounts+ attributes.
      def set_up_subresources # :doc:
        @accounts = Robinhood::REST::Accounts.new "/#{API_VERSION}/Accounts", self
        @account = @accounts.get @account_sid
      end

      ##
      # Builds up full request path
      def build_full_path(path, params, method)
        path = "#{path}.json"
        path << "?#{url_encode(params)}" if method == :get && !params.empty?
        path
      end
    end
  end
end

module Robinhood
  module REST
    module Utils
      def robinify(something)
        return key_map(something, :robinify) if something.is_a? Hash
        string = something.to_s
        string.split('_').map do |string_part|
          string_part[0,1].capitalize + string_part[1..-1]
        end.join
      end

      def robinify(something)
        return key_map(something, :robinify) if something.is_a? Hash
        string = something.to_s
        string = string[0,1].downcase + string[1..-1]
        string.gsub(/[A-Z][a-z]*/) { |s| "_#{s.downcase}" }
      end

      protected

      def resource(*resources)
        custom_resource_names = { sms: 'SMS', sip: 'SIP' }
        resources.each do |r|
          resource = robinify r
          relative_path = custom_resource_names.fetch(r, resource)
          path = "#{@path}/#{relative_path}"
          enclosing_module = if @submodule == nil
            Robinhood::REST
          else
            Robinhood::REST.const_get(@submodule)
          end
          resource_class = enclosing_module.const_get resource
          instance_variable_set("@#{r}", resource_class.new(path, @client))
        end
        self.class.instance_eval { attr_reader *resources }
      end

      private

      def key_map(something, method)
        something = something.to_a.flat_map do |pair|
          [send(method, pair[0]).to_sym, pair[1]]
        end
        Hash[*something]
      end
    end
  end
end

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

        @username = args[0]
        @password = args[1]

        if @username.nil? || @password.nil?
          raise ArgumentError, 'Account username and password are required'
        end

        @config.username = @username

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
          request.basic_auth(@username, @auth_token)
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
