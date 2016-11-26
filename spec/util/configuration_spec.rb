require 'spec_helper'

describe Robinhood::Util::Configuration do
  it 'should have an account sid attribute' do
    config = Robinhood::Util::Configuration.new
    config.username = 'someSid'
    expect(config.username).to eq('someSid')
  end

  it 'should have an auth token attribute' do
    config = Robinhood::Util::Configuration.new
    config.password = 'someToken'
    expect(config.password).to eq('someToken')
  end
end
