require 'spec_helper'

describe Robinhood::REST::Client do
  describe 'config at class level' do
    after(:each) do
      Robinhood.instance_variable_set('@configuration', nil)
    end

    it 'should throw an argument error if the sid and token isn\'t set' do
      expect { Robinhood::REST::Client.new }.to raise_error(ArgumentError)
    end

    it 'should throw an argument error if only the username is set' do
      expect { Robinhood::REST::Client.new 'someSid' }.to raise_error(ArgumentError)
    end

  end
end
