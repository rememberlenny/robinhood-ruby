require "spec_helper"

describe Robinhood do
  it "has a version number" do
    expect(Robinhood::VERSION).not_to be nil
  end
  
  let(:username) {"username"}
  let(:password) {"password"}
  describe "setup the Robinhood::REST::Client" do
    it "fail without config params" do
      expect{ Robinhood::REST::Client.new }.to raise_error(ArgumentError)
    end

    it "access a username and password param" do
      @robinhood = Robinhood::REST::Client.new(username, password)

      expect(@config.username).to be_a String
      expect(@config.username).to eq username
    end

    it "get the access token from the api and store the access token as a local variable" do
      FakeWeb.register_uri(:get, "https://api.robinhood.com/api-token-auth/", :body => {"token"=>"1234567890"})
      @robinhood = Robinhood::REST::Client.new(username, password)
      expect(@robinhood.token).to be_a String
      expect(@robinhood.token).to eq '1234567890'
    end
  end

  describe "setup the Robinhood::Utils::ClientConfig" do
    Robinhood::Util::ClientConfig::DEFAULTS.each do |attribute, value|
      it "sets and attribune with a " + attribute.to_s + " value" do
        config = Robinhood::Util::ClientConfig.new
        expect(config.send(attribute)).to eq(value)
      end

      it "can update the value for the attribute" do
        config = Robinhood::Util::ClientConfig.new
        config.send("#{attribute}=", "blah")
        expect(config.send(attribute)).to eq("blah")
      end

      it "can set the value from a hash in the initializer" do
        config = Robinhood::Util::ClientConfig.new(attribute => 'blah')
        expect(config.send(attribute)).to eq("blah")
      end
    end
  end

  it "make sure tests are working" do
    expect(true).to eq(true)
  end
end
