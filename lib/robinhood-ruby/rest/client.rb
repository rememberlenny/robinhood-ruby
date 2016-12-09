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
          raise ArgumentError, 'Account username and password are required'
        end
        
        setup_headers
        configuration
        setup
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
          login:                    'https://api.robinhood.com/api-token-auth/',
          investment_profile:       'https://api.robinhood.com/user/investment_profile/',
          accounts:                 'https://api.robinhood.com/accounts/',
          ach_iav_auth:             'https://api.robinhood.com/ach/iav/auth/',
          ach_relationships:        'https://api.robinhood.com/ach/relationships/',
          ach_transfers:            'https://api.robinhood.com/ach/transfers/',
          ach_deposit_schedules:    "https://api.robinhood.com/ach/deposit_schedules/",
          applications:             'https://api.robinhood.com/applications/',
          dividends:                'https://api.robinhood.com/dividends/',
          edocuments:               'https://api.robinhood.com/documents/',
          instruments:              'https://api.robinhood.com/instruments/',
          margin_upgrade:           'https://api.robinhood.com/margin/upgrades/',
          markets:                  'https://api.robinhood.com/markets/',
          notifications:            'https://api.robinhood.com/notifications/',
          notifications_devices:    "https://api.robinhood.com/notifications/devices/",
          orders:                   'https://api.robinhood.com/orders/',
          cancel_order:             'https://api.robinhood.com/orders/',
          password_reset:           'https://api.robinhood.com/password_reset/request/',
          quotes:                   'https://api.robinhood.com/quotes/',
          document_requests:        'https://api.robinhood.com/upload/document_requests/',
          user:                     'https://api.robinhood.com/user/',
    
          user_additional_info:     "https://api.robinhood.com/user/additional_info/",
          user_basic_info:          "https://api.robinhood.com/user/basic_info/",
          user_employment:          "https://api.robinhood.com/user/employment/",
          user_investment_profile:  "https://api.robinhood.com/user/investment_profile/",

          watchlists:               'https://api.robinhood.com/watchlists/',
          positions:                'https://api.robinhood.com/positions/',
          fundamentals:             'https://api.robinhood.com/fundamentals/',
          sp500_up:                 'https://api.robinhood.com/midlands/movers/sp500/?direction=up',
          sp500_down:               'https://api.robinhood.com/midlands/movers/sp500/?direction=down',
          news:                     'https://api.robinhood.com/midlands/news/'
        }
      end

      def configuration()
        @api_url = 'https://api.robinhood.com/';

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

      def setup
        @private[:username] = @options[:username];
        @private[:password] = @options[:password];

        if @private[:auth_token].nil?
          login
        end
      end

      def http_request(url)
        request = Util::Request.new(@private)
        request.http_request(url)
      end
     
      def setup_headers
        @headers ||= {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip, deflate',
          'Accept-Language' => 'en;q=1, fr;q=0.9, de;q=0.8, ja;q=0.7, nl;q=0.6, it;q=0.5',
          'Content-Type' => 'application/x-www-form-urlencoded; charset=utf-8',
          'X-Robinhood-API-Version' => '1.0.0',
          'Connection' => 'keep-alive',
          'User-Agent' => 'Robinhood/823 (iPhone; iOS 7.1.2; Scale/2.00)',
        }
      end

      def login
        raw_response = HTTParty.post(
          endpoints[:login],
          body: {
            'password' => @private[:password],
            'username'=> @private[:username]
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