module Robinhood
  module REST
    class Client < API
      attr_accessor :token, :api_url, :options, :endpoints, :private

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

      def endpoints
        {
          login:                    @api_url + "api-token-auth/",
          investment_profile:       @api_url + "user/investment_profile/",
          accounts:                 @api_url + "accounts/",
          ach_iav_auth:             @api_url + "ach/iav/auth/",
          ach_relationships:        @api_url + "ach/relationships/",
          ach_transfers:            @api_url + "ach/transfers/",
          ach_deposit_schedules:    @api_url + "ach/deposit_schedules/",
          applications:             @api_url + "applications/",
          dividends:                @api_url + "dividends/",
          edocuments:               @api_url + "documents/",
          instruments:              @api_url + "instruments/",
          margin_upgrade:           @api_url + "margin/upgrades/",
          markets:                  @api_url + "markets/",
          notifications:            @api_url + "notifications/",
          notifications_devices:    @api_url + "notifications/devices/",
          orders:                   @api_url + "orders/",
          cancel_order:             @api_url + "orders/",
          password_reset:           @api_url + "password_reset/request/",
          quotes:                   @api_url + "quotes/",
          document_requests:        @api_url + "upload/document_requests/",
          user:                     @api_url + "user/",
    
          user_additional_info:     @api_url + "user/additional_info/",
          user_basic_info:          @api_url + "user/basic_info/",
          user_employment:          @api_url + "user/employment/",
          user_investment_profile:  @api_url + "user/investment_profile/",

          watchlists:               @api_url + "watchlists/",
          positions:                @api_url + "positions/",
          fundamentals:             @api_url + "fundamentals/",
          sp500_up:                 @api_url + "midlands/movers/sp500/?direction=up",
          sp500_down:               @api_url + "midlands/movers/sp500/?direction=down",
          news:                     @api_url + "midlands/news/"
        }
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
            endpoints[:login],
            body: {
              "password" => @private[:password],
              "username" => @private[:username]
            }.as_json,
            headers: headers
          )
          response = JSON.parse(raw_response.body)

          if response["non_field_errors"]
            puts response["non_field_errors"]
            false
          elsif response["token"]
            @private[:auth_token] = JSON.parse(response.read_body)["token"]
            @headers["Authorization"] = "Token " + @private[:auth_token].to_s
            @private[:account] = account["results"][0]["url"]
          end

        end
      end

    end
  end
end