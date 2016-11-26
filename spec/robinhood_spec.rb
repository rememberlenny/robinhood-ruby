require "spec_helper"

describe Robinhood do
  let(:username) {"username"}
  let(:password) {"password"}

  it "has a version number" do
    expect(Robinhood::VERSION).not_to be nil
  end

  describe "setup the Robinhood::Utils::ClientConfig" do
    Robinhood::Util::ClientConfig::DEFAULTS.each do |attribute, value|
      it "sets and attribune with a default value" do
        config = Robinhood::Util::ClientConfig.new
        expect(config.send(attribute)).to eq(value)
      end
    end
  end

  describe "setup the Robinhood::REST::Client" do
    it "fail without config params" do
      expect{ Robinhood::REST::Client.new }.to raise_error(ArgumentError)
    end

    it "access a username and password param" do
      @robinhood = Robinhood::REST::Client.new username, password 
      expect(@robinhood.username).to be_a String
      expect(@robinhood.username).to eq username
      expect(@robinhood.password).to be_a String
      expect(@robinhood.password).to eq password
    end

    it "get the access token from the api and store the access token as a local variable" do
      FakeWeb.register_uri(:get, "https://api.robinhood.com/api-token-auth/", :body => {"token"=>"1234567890"})
      @robinhood = Robinhood::REST::Client.new username, password 
      expect(@robinhood.token).to be_a String
      expect(@robinhood.token).to eq '1234567890'
    end
  end

  it "make sure tests are working" do
    expect(true).to eq(true)
  end
end
