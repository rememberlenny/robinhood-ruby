require 'spec_helper'

describe Robinhood::Util::Configuration do
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
end
