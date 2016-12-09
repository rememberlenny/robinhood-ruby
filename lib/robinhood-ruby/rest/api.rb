module Robinhood
  module REST
    class API
      def account
        raw_response = HTTParty.get(endpoints[:accounts], headers: headers)
        JSON.parse(raw_response.body)
      end
      
      def investment_profile
        raw_response = HTTParty.get(endpoints[:investment_profile], headers: headers)
        JSON.parse(raw_response.body)
      end

      def fundamentals(ticker)
        raw_response = HTTParty.get(endpoints[:fundamentals], query: {"symbols" => ticker.upcase}, headers: headers)
        JSON.parse(raw_response.body)
      end

      def instruments(symbol)
        raw_response = HTTParty.get(endpoints[:instruments], query: {"query" => symbol.upcase}, headers: headers)
        JSON.parse(raw_response.body)
      end

      def quote_data(symbol)
        raw_response = HTTParty.post(@api_url + "quotes/#{symbol}/", headers: headers)
        JSON.parse(raw_response.body)
      end

      def user
        raw_response = HTTParty.get(endpoints[:user], headers: headers)
        JSON.parse(raw_response.body)
      end

      def dividends
        raw_response = HTTParty.get(endpoints[:dividends], headers: headers)
        JSON.parse(raw_response.body)
      end

      def orders
        raw_response = HTTParty.get(endpoints[:orders], headers: headers)
        JSON.parse(raw_response.body)
      end

      def buy(symbol, instrument_id, price, quantity)
        raw_response = HTTParty.post(
          endpoints[:orders],
          body: {
            "account" => @private.account,
            "instrument" => @api_url + "instruments/#{instrument_id}/",
            "price" => price,
            "quantity" => quantity,
            "side" => "buy",
            "symbol" => symbol,
            "time_in_force" => "gfd",
            "trigger" => "immediate",
            "type" => "market"
          }.as_json,
          headers: headers
        )
      end

      def limit_buy(symbol, instrument_id, price, quantity)
        raw_response = HTTParty.post(
          endpoints[:orders],
          body: {
            "account" => @private.account,
            "instrument" => @api_url + "instruments/#{instrument_id}/",
            "price" => price,
            "quantity" => quantity,
            "side" => "buy",
            "symbol" => symbol,
            "time_in_force" => "gfd",
            "trigger" => "immediate",
            "type" => "limit"
          }.as_json,
          headers: headers
        )
      end

      def sell(symbol, instrument_id, price, quantity)
        raw_response = HTTParty.post(
          endpoints[:orders],
          body: {
            "account" => @private.account,
            "instrument" => @api_url + "instruments/#{instrument_id}/",
            "price" => price,
            "quantity" => quantity,
            "side" => "sell",
            "symbol" => symbol,
            "time_in_force" => "gfd",
            "trigger" => "immediate",
            "type" => "market"
          }.as_json,
          headers: headers
        )
      end

      def limit_sell(symbol, instrument_id, price, quantity)
        raw_response = HTTParty.post(
          endpoints[:orders],
          body: {
            "account" => @private.account,
            "instrument" => @api_url + "instruments/#{instrument_id}/",
            "price" => price,
            "quantity" => quantity,
            "side" => "sell",
            "symbol" => symbol,
            "time_in_force" => "gfd",
            "trigger" => "immediate",
            "type" => "limit"
          }.as_json,
          headers: headers
        )
      end

      def stop_loss_sell(symbol, instrument_id, price, quantity)
        raw_response = HTTParty.post(
          endpoints[:orders],
          body: {
            "account" => @private.account,
            "instrument" => @api_url + "instruments/#{instrument_id}/",
            "stop_price" => price,
            "quantity" => quantity,
            "side" => "sell",
            "symbol" => symbol,
            "time_in_force" => "gtc",
            "trigger" => "stop",
            "type" => "market"
          }.as_json,
          headers: headers
        )
      end

      def cancel_order(order_id)
        raw_response = HTTParty.post(@api_url + "orders/#{order_id}/cancel/", headers: headers)
        raw_response.code == 200
      end

      def positions(instrument_id)
        raw_response = HTTParty.get(@private.account + "/positions/#{instrument_id}/", headers: headers)
        JSON.parse(raw_response.body)
      end

      def positions
        raw_response = HTTParty.get(endpoints[:positions], headers: headers)
        JSON.parse(raw_response.body)
      end      

      def news(symbol)
        raw_response = HTTParty.get(endpoints[:news] + symbol.to_s + "/", headers: headers)
        JSON.parse(raw_response.body)
      end      

      def markets
        raw_response = HTTParty.get(endpoints[:markets], headers: headers)
        JSON.parse(raw_response.body)
      end      

      def sp500_up
        raw_response = HTTParty.get(endpoints[:sp500_up], headers: headers)
        JSON.parse(raw_response.body)
      end      

      def sp500_down
        raw_response = HTTParty.get(endpoints[:sp500_down], headers: headers)
        JSON.parse(raw_response.body)
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
        raw_response = HTTParty.get(endpoints[:watchlists], headers: headers)
        JSON.parse(raw_response.body)
      end

      def splits(instrument)
        raw_response = HTTParty.get(endpoints[:instruments] + "/splits/" + instrument.to_s, headers: headers)
        JSON.parse(raw_response.body)
      end

      def historicals(symbol, intv, span)
        raw_response = HTTParty.get(endpoints[:quotes] + "historicals/" + symbol, query: {"interval" => intv.to_s, "span" => span}, headers: headers)
        JSON.parse(raw_response.body)
      end
    end
  end
end