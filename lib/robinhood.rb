require 'net/http'
require 'net/https'
require 'builder'
require 'multi_json'
require 'cgi'
require 'openssl'
require 'base64'
require 'forwardable'
require 'jwt'
require 'singleton'

require "robinhood/version"

module Robinhood
  extend SingleForwardable

  def_delegators :configuration, :username, :password

  ##
  # Pre-configure with account SID and auth token so that you don't need to
  # pass them to various initializers each time.
  def self.configure(&block)
    yield configuration
  end

  ##
  # Returns an existing or instantiates a new configuration object.
  def self.configuration
    @configuration ||= Util::Configuration.new
  end
  private_class_method :configuration
end

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