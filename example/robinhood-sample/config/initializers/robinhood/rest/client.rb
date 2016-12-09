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

      def configuration
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
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = prepare_request(url)

        response = http.request(request)
      end

      def setup_headers(request)
        request["accept"] = '*/*'
        request["accept-encoding"] = 'gzip, deflate'
        request["accept-language"] = 'en;q=1, fr;q=0.9, de;q=0.8, ja;q=0.7, nl;q=0.6, it;q=0.5'
        request["content-type"] = 'multipart/form-data; boundary=---011000010111000001101001'
        request["x-robinhood-api-version"] = '1.0.0'
        request["connection"] = 'keep-alive'
        request["user-agent"] = 'Robinhood/823 (iPhone; iOS 7.1.2; Scale/2.00)'
        request["cache-control"] = 'no-cache'
        request
      end

      def prepare_request(url)
        if @private[:auth_token].nil?
          request = Net::HTTP::Post.new(url)
        else
          request = Net::HTTP::Get.new(url)
        end
        request = setup_headers(request)

        if @private[:auth_token].nil?
          request["authorization"] = 'Basic cmVtZW1iZXJsZW5ueTpPbmx5RGVzdGlueTgh'
          request.body = "-----011000010111000001101001\r\nContent-Disposition: form-data; name=\"username\"\r\n\r\n" + @private[:username] + "\r\n-----011000010111000001101001\r\nContent-Disposition: form-data; name=\"password\"\r\n\r\n" + @private[:password] + "\r\n-----011000010111000001101001\r\nContent-Disposition: form-data; name=\"\"\r\n\r\n\r\n-----011000010111000001101001--"
        else
          request["authorization"] = 'Token ' + @private[:auth_token].to_s
          request.body = "-----011000010111000001101001\r\nContent-Disposition: form-data; name=\"username\"\r\n\r\n\r\n-----011000010111000001101001\r\nContent-Disposition: form-data; name=\"password\"\r\n\r\n\r\n-----011000010111000001101001\r\nContent-Disposition: form-data; name=\"\"\r\n\r\n\r\n-----011000010111000001101001--"
        end
        request
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