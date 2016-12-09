require 'uri'
require 'net/http'

module Robinhood
  class Configuration
    attr_accessor :token, :api_url, :options, :endpoints, :private
    
    def initialize(opts, callback = nil)
      configuration(opts)
      setup
      puts @private[:auth_token]
    end

    def configuration(opts)
      @api_url = 'https://api.robinhood.com/';

      @options = opts || {}

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

      login
    end

    def login
      url = URI(@api_url + "api-token-auth/")

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Post.new(url)
      request["accept"] = '*/*'
      request["accept-encoding"] = 'gzip, deflate'
      request["accept-language"] = 'en;q=1, fr;q=0.9, de;q=0.8, ja;q=0.7, nl;q=0.6, it;q=0.5'
      request["content-type"] = 'multipart/form-data; boundary=---011000010111000001101001'
      request["x-robinhood-api-version"] = '1.0.0'
      request["connection"] = 'keep-alive'
      request["user-agent"] = 'Robinhood/823 (iPhone; iOS 7.1.2; Scale/2.00)'
      request["authorization"] = 'Basic cmVtZW1iZXJsZW5ueTpPbmx5RGVzdGlueTgh'
      request["cache-control"] = 'no-cache'
      request["postman-token"] = 'c8c14c2c-af95-ade8-783d-b20565822cf5'
      request.body = "-----011000010111000001101001\r\nContent-Disposition: form-data; name=\"username\"\r\n\r\n" + @private[:username] + "\r\n-----011000010111000001101001\r\nContent-Disposition: form-data; name=\"password\"\r\n\r\n" + @private[:password] + "\r\n-----011000010111000001101001\r\nContent-Disposition: form-data; name=\"\"\r\n\r\n\r\n-----011000010111000001101001--"

      response = http.request(request)

      @private[:auth_token] = JSON.parse(response.read_body)["token"]
    end
  end
end