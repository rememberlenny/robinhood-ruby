module Robinhood
  module REST
    class API
      def account
        url = URI(@api_url + @endpoints[:accounts])
        response = http_request(url)
        puts response.read_body
      end
      
      def investment_profile
        url = URI(@api_url + @endpoints[:investment_profile])
        response = http_request(url)
        puts response.read_body
      end

      def fundamentals(ticker)
        url = URI(@api_url + @endpoints[:fundamentals] + "?symbols=" + ticker.to_s)
        response = http_request(url)
        puts response.read_body
      end

      def instruments(symbol)
        url = URI(@api_url + @endpoints[:instruments] + "?query=" + symbol.to_s)
        response = http_request(url)
        puts response.read_body
      end

      def quote_data(symbol)
        symbol = symbol.is_a?(Array) ? symbol.join(',') : symbol;
        url = URI(@api_url + @endpoints[:quotes] + "?symbols=" + symbol.to_s)
        response = http_request(url)
        puts response.read_body
      end

      def user
        url = URI(@api_url + @endpoints[:user])
        response = http_request(url)
        puts response.read_body
      end

      def dividends
        url = URI(@api_url + @endpoints[:dividends])
        response = http_request(url)
        puts response.read_body
      end

      def orders
        url = URI(@api_url + @endpoints[:orders])
        response = http_request(url)
        puts response.read_body
      end

      # def cancel_order(order)
      #   if order[:cancel]
      #     url = URI(@api_url + @endpoints[:cancel])
      #   else
      #   end
      #   response = http_request(url)
      #   puts response.read_body
      # end

      # def place_order(options, callback)
      # return _request.post({
      #   uri: @api_url + @endpoints.orders,
      #   form: {
      #     account: _private.account,
      #     instrument: options.instrument.url,
      #     price: options.bid_price,
      #     stop_price: options.stop_price,
      #     quantity: options.quantity,
      #     side: options.transaction,
      #     symbol: options.instrument.symbol.toUpperCase(),
      #     time_in_force: options.time || 'gfd',
      #     trigger: options.trigger || 'immediate',
      #     type: options.type || 'market'
      #   }
      # }, callback);
      # end

      # def place_buy_order(options, callback)
      # options.transaction = 'buy';
      # return _place_order(options, callback);
      # end

      # def place_sell_order(options, callback)
      # options.transaction = 'sell';
      # return _place_order(options, callback);
      # end      

      def positions
        url = URI(@api_url + @endpoints[:positions])
        response = http_request(url)
        puts response.read_body
      end      

      def news(symbol)
        url = URI(@api_url + @endpoints[:news] + symbol.to_s + "/")
        response = http_request(url)
        puts response.read_body
      end      

      def markets
        url = URI(@api_url + @endpoints[:markets])
        response = http_request(url)
        puts response.read_body
      end      

      def sp500_up
        url = URI(@api_url + @endpoints[:sp500_up])
        response = http_request(url)
        puts response.read_body
      end      

      def sp500_down
        url = URI(@api_url + @endpoints[:sp500_down])
        response = http_request(url)
        puts response.read_body
      end      

      # def create_watch_list(name, callback)
      # return _request.post({
      #   uri: @api_url + @endpoints.watchlists,
      #   form: {
      #     name: name
      #   }
      # }, callback);
      # end

      def watchlists
        url = URI(@api_url + @endpoints[:watchlists])
        response = http_request(url)
        puts response.read_body
      end

      def splits(instrument)
        url = URI(@api_url + @endpoints[:instruments] + "/splits/" + instrument.to_s)
        response = http_request(url)
        puts response.read_body
      end

      def historicals(symbol, intv, span)
        url = URI(@api_url + @endpoints[:quotes] + "historicals/" + symbol + "?interval" + intv.to_s + "&span=" + span)
        response = http_request(url)
        puts response.read_body
      end
    end

  end
end