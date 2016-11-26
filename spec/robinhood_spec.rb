require "spec_helper"

describe Robinhood do
  it "has a version number" do
    expect(Robinhood::VERSION).not_to be nil
  end
 
  after(:each) do
    Robinhood.instance_variable_set('@configuration', nil)
  end

  it 'should set the username and password with a config block' do
    Robinhood.configure do |config|
      config.username = 'someUser'
      config.password = 'somePass'
    end

    expect(Robinhood.username).to eq('someUser')
    expect(Robinhood.password).to eq('somePass')
  end
end