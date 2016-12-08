require 'spec_helper'

describe Robinhood::REST::Client do
  describe 'config at class level' do
    after(:each) do
      Robinhood.instance_variable_set('@configuration', nil)
    end

    it 'should set the account sid and auth token with a config block' do
      Robinhood.configure do |config|
        config.username = 'someSid'
        config.password = 'someToken'
      end

      client = Robinhood::REST::Client.new
      expect(client.username).to eq('someSid')
      expect(client.instance_variable_get('@password')).to eq('someToken')
    end

    it 'should overwrite account sid and auth token if passed to initializer' do
      Robinhood.configure do |config|
        config.username = 'someSid'
        config.password = 'someToken'
      end

      client = Robinhood::REST::Client.new 'otherSid', 'otherToken'
      expect(client.username).to eq('otherSid')
      expect(client.instance_variable_get('@password')).to eq('otherToken')
    end

    it 'should overwrite the account sid if only the sid is given' do
      Robinhood.configure do |config|
        config.username = 'someSid'
        config.password = 'someToken'
      end

      client = Robinhood::REST::Client.new 'otherSid'
      expect(client.username).to eq('otherSid')
      expect(client.instance_variable_get('@password')).to eq('someToken')
    end

    it 'should allow options after setting up auth with config' do
      Robinhood.configure do |config|
        config.username = 'someSid'
        config.password = 'someToken'
      end

      client = Robinhood::REST::Client.new :host => 'api.fakerobinhood.com'

      connection = client.instance_variable_get('@connection')
      expect(connection.address).to eq('api.fakerobinhood.com')
    end

    it 'should throw an argument error if the sid and token isn\'t set' do
      expect { Robinhood::REST::Client.new }.to raise_error(ArgumentError)
    end

    it 'should throw an argument error if only the username is set' do
      expect { Robinhood::REST::Client.new 'someSid' }.to raise_error(ArgumentError)
    end

    it 'should not raise an error if the response body is empty' do
      FakeWeb.register_uri(:any, %r/api\.robinhood\.com/, body: '')
      robinhood = Robinhood::REST::Client.new('someSid', 'someToken')
      robinhood.pry
    end

    it 'should respond to fake token request' do
      url = "api.robinhood.com"
      FakeWeb.register_uri(:post, "http://" + url + "/api-token-auth/", :body => "Unauthorized", :status => ["401", "Unauthorized"])
      FakeWeb.register_uri(:post, "http://someSid:someToken@" + url + "/api-token-auth/", :body => "Authorized")
      
      Robinhood.configure do |config|
        config.username = 'someSid'
        config.password = 'someToken'
      end

      client = Robinhood::REST::Client.new

      Net::HTTP.start(url) do |https|
        req = Net::HTTP::Post.new("/api-token-auth/")
        https.request(req)  # => "Unauthorized"
        expect (https.request(req) ).to eq('Unauthorized')
        req.basic_auth("someSid", "someToken")
        https.request(req)  # => "Authorized"
        expect (https.request(req) ).to eq('Authorized')
      end

    end
  end
end
