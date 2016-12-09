module Robinhood
  module REST
    class Endpoints
      attr_accessor :endpoints
      
      def initialize
      end

      def self.endpoints
        api_url = "https://api.robinhood.com/"
        {
          login:                    api_url + "api-token-auth/",
          investment_profile:       api_url + "user/investment_profile/",
          accounts:                 api_url + "accounts/",
          ach_iav_auth:             api_url + "ach/iav/auth/",
          ach_relationships:        api_url + "ach/relationships/",
          ach_transfers:            api_url + "ach/transfers/",
          ach_deposit_schedules:    api_url + "ach/deposit_schedules/",
          applications:             api_url + "applications/",
          dividends:                api_url + "dividends/",
          edocuments:               api_url + "documents/",
          instruments:              api_url + "instruments/",
          margin_upgrade:           api_url + "margin/upgrades/",
          markets:                  api_url + "markets/",
          notifications:            api_url + "notifications/",
          notifications_devices:    api_url + "notifications/devices/",
          orders:                   api_url + "orders/",
          cancel_order:             api_url + "orders/",
          password_reset:           api_url + "password_reset/request/",
          quotes:                   api_url + "quotes/",
          document_requests:        api_url + "upload/document_requests/",
          user:                     api_url + "user/",

          user_additional_info:     api_url + "user/additional_info/",
          user_basic_info:          api_url + "user/basic_info/",
          user_employment:          api_url + "user/employment/",
          user_investment_profile:  api_url + "user/investment_profile/",

          watchlists:               api_url + "watchlists/",
          positions:                api_url + "positions/",
          fundamentals:             api_url + "fundamentals/",
          sp500_up:                 api_url + "midlands/movers/sp500/?direction=up",
          sp500_down:               api_url + "midlands/movers/sp500/?direction=down",
          news:                     api_url + "midlands/news/"
        }
      end
    end
  end
end