require 'spec_helper'

describe Robinhood::REST::Client do
  describe 'config at class level' do
    
    after(:each) do
      Robinhood.instance_variable_set('@configuration', nil)
    end

    it "fail without config params" do
      expect{ Robinhood::REST::Client.new }.to raise_error(ArgumentError)
    end

    it "access a username and password param" do
      Robinhood.configure do |config|
        config.username = 'someSid'
        config.password = 'someToken'
      end

      client = Robinhood::REST::Client.new

      expect(client.username).to be_a String
      expect(client.username).to eq 'someSid'
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
