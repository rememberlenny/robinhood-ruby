module Robinhood
  module Util
    class Request
      def initialize(private_params)
        @private = private_params
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
    end
  end
end