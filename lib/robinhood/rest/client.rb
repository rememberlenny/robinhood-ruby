require 'robinhood/rest/base_client'

module Robinhood
  module REST
    class Client < BaseClient
      API_VERSION = ""
      attr_reader :account, :accounts

      host 'api.robinhood.com'
      

      def initialize(*args)
        super(*args)
      end

      protected

      ##
      # Builds up full request path
      def build_full_path(path, params, method)
        path = "#{path}.json"
        path << "?#{url_encode(params)}" if method == :get && !params.empty?
        path
      end
    end
  end
end