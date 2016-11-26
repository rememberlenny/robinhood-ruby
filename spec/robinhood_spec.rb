require "spec_helper"

describe Robinhood do
  it "has a version number" do
    expect(Robinhood::VERSION).not_to be nil
  end

  describe "setup the robinhood object and" do
    it "fail without config params" do
      pending
    end

    it "access a username and password param" do
      pending
    end

    it "get the access token from the api" do
      pending
    end

    it "store the access token as a local variable" do
      pending
    end
  end

  it "make sure tests are working" do
    expect(true).to eq(true)
  end
end
