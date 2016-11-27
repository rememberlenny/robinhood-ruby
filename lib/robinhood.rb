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

require "robinhood/version" unless defined?(Robinhood::VERSION)

require 'robinhood/util'
require 'robinhood/util/client_config'
require 'robinhood/util/configuration'
require 'robinhood/util/request_validator'

require 'robinhood/rest/errors'
require 'robinhood/rest/utils'

require 'robinhood/rest/client'

require 'rack/robinhood_webhook_authentication'

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
