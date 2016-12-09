module Robinhood
  module REST
    class API
      def account
        url = URI(@api_url + @endpoints.accounts)
        response = http_request(url)
        puts response.read_body
      end
      
      class investment_profile
        url = URI(@api_url + @endpoints.investment_profile)
        response = http_request(url)
        puts response.read_body
      end

      class fundamentals(ticker)
        url = URI(@api_url + @endpoints.fundamentals + "?symbols=" + ticker.to_s)
      end
    end
  end
end