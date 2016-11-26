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

      client = Robinhood::REST::Client.new :host => 'api.faketwilio.com'

      connection = client.instance_variable_get('@connection')
      expect(connection.address).to eq('api.faketwilio.com')
    end

    it 'should throw an argument error if the sid and token isn\'t set' do
      expect { Robinhood::REST::Client.new }.to raise_error(ArgumentError)
    end

    it 'should throw an argument error if only the username is set' do
      expect { Robinhood::REST::Client.new 'someSid' }.to raise_error(ArgumentError)
    end

    it "get the access token from the api and store the access token as a local variable" do
      FakeWeb.register_uri(:get, "https://api.robinhood.com/api-token-auth/", :body => {"token"=>"1234567890"})
      
      Robinhood.configure do |config|
        config.username = 'someSid'
        config.password = 'someToken'
      end

      client = Robinhood::REST::Client.new

      expect(client.token).to be_a String
      expect(client.token).to eq '1234567890'
    end
  end
end
