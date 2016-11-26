require 'singleton'
require "robinhood/version"

module Robinhood
  module REST
    class Client
      def initialize(username=nil, password=nil)
        if @username.nil? || @password.nil?
          raise ArgumentError, 'Account username and password are required'
        end
      end
    end
  end
end
