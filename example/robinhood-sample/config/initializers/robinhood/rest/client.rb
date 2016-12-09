module Robinhood
  module REST
    class Client
      attr_accessor :token, :api_url, :options, :endpoints, :private

      def initialize(*args)
        super(*args)

        @options = args.last.is_a?(Hash) ? args.pop : {}

        @options[:username] = args[0] || Robinhood.username
        @options[:password] = args[1] || Robinhood.password
        @options[:username] = (args.size > 2 && args[2].is_a?(String) ? args[2] : args[0]) || Robinhood.username

        if @options[:username].nil? || @options[:password].nil?
          raise ArgumentError, 'Account username and password are required'
        end

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

      def configuration()
        @api_url = 'https://api.robinhood.com/';

        @endpoints = {
          "login":                    'api-token-auth/',
          "investment_profile":       'user/investment_profile/',
          "accounts":                 'accounts/',
          "ach_iav_auth":             'ach/iav/auth/',
          "ach_relationships":        'ach/relationships/',
          "ach_transfers":            'ach/transfers/',
          "ach_deposit_schedules":    "ach/deposit_schedules/",
          "applications":             'applications/',
          "dividends":                'dividends/',
          "edocuments":               'documents/',
          "instruments":              'instruments/',
          "margin_upgrade":           'margin/upgrades/',
          "markets":                  'markets/',
          "notifications":            'notifications/',
          "notifications_devices":    "notifications/devices/",
          "orders":                   'orders/',
          "cancel_order":             'orders/', #API expects https://api.robinhood.com/orders/{{orderId}}/cancel/
          "password_reset":           'password_reset/request/',
          "quotes":                   'quotes/',
          "document_requests":        'upload/document_requests/',
          "user":                     'user/',
    
          "user_additional_info":     "user/additional_info/",
          "user_basic_info":          "user/basic_info/",
          "user_employment":          "user/employment/",
          "user_investment_profile":  "user/investment_profile/",

          "watchlists":               'watchlists/',
          "positions":                'positions/',
          "fundamentals":             'fundamentals/',
          "sp500_up":                 'midlands/movers/sp500/?direction=up',
          "sp500_down":               'midlands/movers/sp500/?direction=down',
          "news":                     'midlands/news/'
        }

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
        request = Robinhood::Util::Request.new(@private)
        request.http_request(url)
      end

      def login
        url = URI(@api_url + "api-token-auth/")
        response = http_request(url)
        @private[:auth_token] = JSON.parse(response.read_body)["token"]
        account
      end

      def account
        url = URI(@api_url + "accounts/")
        response = http_request(url)
        puts response.read_body
      end
    end
  end
end