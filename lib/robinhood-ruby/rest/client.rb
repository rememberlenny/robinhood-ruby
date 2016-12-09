module Robinhood
  module REST
    class Client < API
      attr_accessor :token, :options, :private, :headers

      def initialize(*args)
        @options = args.last.is_a?(Hash) ? args.pop : {}

        @options[:username] = args[0] || Robinhood.username
        @options[:password] = args[1] || Robinhood.password
        @options[:username] = (args.size > 2 && args[2].is_a?(String) ? args[2] : args[0]) || Robinhood.username

        if @options[:username].nil? || @options[:password].nil?
          raise ArgumentError, "Account username and password are required"
        end
        
        setup_headers
        configuration
        login
      end

      def inspect # :nodoc:
        "<Robinhood::REST::Client @username=#{@options[:username]}>"
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

      def configuration()
        @api_url = "https://api.robinhood.com/"

        @is_init = false
        
        @private = {
          "session":     {},
          "account":     nil,
          "username":    nil,
          "password":    nil,
          "headers":     nil,
          "auth_token":  nil
        }

        @api = {}
      end
     
      def setup_headers
        @headers ||= {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip, deflate",
          "Accept-Language" => "en;q=1, fr;q=0.9, de;q=0.8, ja;q=0.7, nl;q=0.6, it;q=0.5",
          "Content-Type" => "application/x-www-form-urlencoded; charset=utf-8",
          "X-Robinhood-API-Version" => "1.0.0",
          "Connection" => "keep-alive",
          "User-Agent" => "Robinhood/823 (iPhone; iOS 7.1.2; Scale/2.00)",
        }
      end

      def login
        @private[:username] = @options[:username]
        @private[:password] = @options[:password]

        if @private[:auth_token].nil?
          raw_response = HTTParty.post(
            @api_url + "api-token-auth/",
            body: {
              "password" => @private[:password],
              "username" => @private[:username]
            }.as_json,
            headers: @headers
          )
          response = JSON.parse(raw_response.body)

          if response["non_field_errors"]
            puts response["non_field_errors"]
            false
          elsif response["token"]
            @private[:auth_token] = response["token"]
            @headers["Authorization"] = "Token " + @private[:auth_token].to_s
            @private[:account] = account["results"][0]["url"]
          end
        end
      end
    end
  end
end