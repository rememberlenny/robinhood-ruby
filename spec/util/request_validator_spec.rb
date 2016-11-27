require 'spec_helper'

describe Robinhood::Util::RequestValidator do
  describe 'configuration' do
    after(:each) do
      Robinhood.instance_variable_set('@configuration', nil)
    end

    it 'should set the auth token from a configuration block' do
      Robinhood.configure do |config|
        config.password = 'someToken'
      end

      validator = Robinhood::Util::RequestValidator.new
      expect(validator.instance_variable_get('@password')).to eq('someToken')
    end

    it 'should overwrite the auth token if passed to initializer' do
      Robinhood.configure do |config|
        config.password = 'someToken'
      end

      validator = Robinhood::Util::RequestValidator.new 'otherToken'
      expect(validator.instance_variable_get('@password')).to eq('otherToken')
    end

    it 'should throw an argument error if the auth token isn\'t set' do
      expect { Robinhood::Util::RequestValidator.new }.to raise_error(ArgumentError)
    end
  end

  describe 'validations' do
    let(:token) { '2bd9e9638872de601313dc77410d3b23' }

    let(:validator) { Robinhood::Util::RequestValidator.new token }
  end
end
