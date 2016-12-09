module Robinhood
  module REST
    class API
      def account
        url = URI(@api_url + @endpoints[:accounts])
        response = http_request(url)
        puts response.read_body
        JSON.parse(response.read_body)
      end
      
      def investment_profile
        url = URI(@api_url + @endpoints[:investment_profile])
        response = http_request(url)
        puts response.read_body
        JSON.parse(response.read_body)
      end

      def fundamentals(ticker)
        url = URI(@api_url + @endpoints[:fundamentals] + "?symbols=" + ticker.to_s)
        response = http_request(url)
        puts response.read_body
        JSON.parse(response.read_body)
      end

      def instruments(symbol)
        url = URI(@api_url + @endpoints[:instruments] + "?query=" + symbol.to_s)
        response = http_request(url)
        puts response.read_body
        JSON.parse(response.read_body)
      end

      def quote_data(symbol)
        symbol = symbol.is_a?(Array) ? symbol.join(',') : symbol;
        url = URI(@api_url + @endpoints[:quotes] + "?symbols=" + symbol.to_s)
        response = http_request(url)
        puts response.read_body
        JSON.parse(response.read_body)
      end

      def user
        url = URI(@api_url + @endpoints[:user])
        response = http_request(url)
        puts response.read_body
        JSON.parse(response.read_body)
      end

      def dividends
        url = URI(@api_url + @endpoints[:dividends])
        response = http_request(url)
        puts response.read_body
        JSON.parse(response.read_body)
      end

      def orders
        url = URI(@api_url + @endpoints[:orders])
        response = http_request(url)
        puts response.read_body
        JSON.parse(response.read_body)
      end

      # def cancel_order(order)
      #   if(order.cancel){
      #     return _request.post({
      #       uri: _apiUrl + order.cancel
      #     }, callback);
      #   }else{
      #     callback({message: order.state=="cancelled" ? "Order already cancelled." : "Order cannot be cancelled.", order: order }, null, null);
      #   };
      # }

      def place_order(options)
        url = URI(@api_url + @endpoints[:orders])
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        form = {
          account: _private.account,
          instrument: options.instrument.url,
          price: options.bid_price,
          stop_price: options.stop_price,
          quantity: options.quantity,
          side: options.transaction,
          symbol: options.instrument.symbol.toUpperCase(),
          time_in_force: options.time || 'gfd',
          trigger: options.trigger || 'immediate',
          type: options.type || 'market'
        }

        request = Net::HTTP::Post.new(url)
        request["accept"] = '*/*'
        request["accept-encoding"] = 'gzip, deflate'
        request["accept-language"] = 'en;q=1, fr;q=0.9, de;q=0.8, ja;q=0.7, nl;q=0.6, it;q=0.5'
        request["content-type"] = 'multipart/form-data; boundary=---011000010111000001101001'
        request["x-robinhood-api-version"] = '1.0.0'
        request["connection"] = 'keep-alive'
        request["user-agent"] = 'Robinhood/823 (iPhone; iOS 7.1.2; Scale/2.00)'
        request["authorization"] = 'Token ' + @private[:auth_token]
        request["cache-control"] = 'no-cache'
        request.body = "-----011000010111000001101001\r\nContent-Disposition: form-data; name=\"account\"\r\n\r\n"+form[:account]+"\r\n-----011000010111000001101001\r\nContent-Disposition: form-data; name=\"instrument\"\r\n\r\n"+form[:instrument]+"\r\n-----011000010111000001101001\r\nContent-Disposition: form-data; name=\"price\"\r\n\r\n"+form[:price]+"\r\n-----011000010111000001101001\r\nContent-Disposition: form-data; name=\"stop_price\"\r\n\r\n"+form[:stop_price]+"\r\n-----011000010111000001101001\r\nContent-Disposition: form-data; name=\"quantity\"\r\n\r\n"+form[:quantity]+"\r\n-----011000010111000001101001\r\nContent-Disposition: form-data; name=\"side\"\r\n\r\n"+form[:side]+"\r\n-----011000010111000001101001\r\nContent-Disposition: form-data; name=\"symbol\"\r\n\r\n"+form[:symbol]+"\r\n-----011000010111000001101001\r\nContent-Disposition: form-data; name=\"time_in_force\"\r\n\r\n"+form[:time_in_force]+"\r\n-----011000010111000001101001\r\nContent-Disposition: form-data; name=\"trigger\"\r\n\r\n"+form[:trigger]+"\r\n-----011000010111000001101001\r\nContent-Disposition: form-data; name=\"type\"\r\n\r\n"+form[:type]+"\r\n-----011000010111000001101001--"

        response = http.request(request)
        puts response.read_body
        JSON.parse(response.read_body)
      end

      def place_buy_order(options)
        options[:transaction] = 'buy'
        place_order(options)
      end

      def place_sell_order(options)
        options[:transaction] = 'sell'
        place_order(options)
      end      

      def positions
        url = URI(@api_url + @endpoints[:positions])
        response = http_request(url)
        puts response.read_body
        JSON.parse(response.read_body)
      end      

      def news(symbol)
        url = URI(@api_url + @endpoints[:news] + symbol.to_s + "/")
        response = http_request(url)
        puts response.read_body
        JSON.parse(response.read_body)
      end      

      def markets
        url = URI(@api_url + @endpoints[:markets])
        response = http_request(url)
        puts response.read_body
        JSON.parse(response.read_body)
      end      

      def sp500_up
        url = URI(@api_url + @endpoints[:sp500_up])
        response = http_request(url)
        puts response.read_body
        JSON.parse(response.read_body)
      end      

      def sp500_down
        url = URI(@api_url + @endpoints[:sp500_down])
        response = http_request(url)
        puts response.read_body
        JSON.parse(response.read_body)
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
        JSON.parse(response.read_body)
      end

      def splits(instrument)
        url = URI(@api_url + @endpoints[:instruments] + "/splits/" + instrument.to_s)
        response = http_request(url)
        puts response.read_body
        JSON.parse(response.read_body)
      end

      def historicals(symbol, intv, span)
        url = URI(@api_url + @endpoints[:quotes] + "historicals/" + symbol + "?interval" + intv.to_s + "&span=" + span)
        response = http_request(url)
        puts response.read_body
        JSON.parse(response.read_body)
      end
    end

  end
end