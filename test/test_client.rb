require 'test_helper'

describe Continuum::Client do
  before do
    @client = Continuum::Client.new '10.3.172.58', '4242'
  end

  describe :aggregators do
    before do
      VCR.use_cassette 'aggregators', :record => :new_episodes do
        @aggregators = @client.aggregators
      end
    end

    it 'returns all the aggregators' do
      assert_equal ["min","sum","max","avg"], @aggregators
    end
  end
end
