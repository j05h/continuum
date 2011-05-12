require 'test_helper'

describe Continuum::Client do
  before do
    @client = Continuum::Client.new '10.3.172.58', '4242'
  end

  describe :aggregators do
    before do
      VCR.use_cassette 'aggregators' do
        @aggregators = @client.aggregators
      end
    end

    it 'returns all the aggregators' do
      assert_equal ["min","sum","max","avg"], @aggregators
    end
  end

  describe :logs do
    before do
      VCR.use_cassette 'logs' do
        @logs = @client.logs
      end
    end

    it 'returns an array of logs' do
      assert 1024, @logs.length
    end

    it 'has an approprate log message' do
      assert_match /New I\/O server boss #1/, @logs.first
    end
  end

  describe :query do
    describe :json do
      before do
        VCR.use_cassette 'query_json' do
          @data = @client.query(
            :start => '2h-ago',
            :m     => ['sum:rate:proc.net.bytes', 'sum:rate:proc.stat.cpu']
          )
        end
      end

      it 'should return metadata points' do
        expected = {"plotted"=>611, "points"=>1719, "etags"=>[["direction"], ["type"]], "timing"=>294}
        assert_equal expected, @data
      end
    end

    describe :ascii do
      before do
        VCR.use_cassette 'query_ascii' do
          @data = @client.query(
            :format => 'ascii',
            :start  => Time.new(2011,5,12,9,44,29),
            :m      => ['sum:rate:proc.net.bytes', 'sum:rate:proc.stat.cpu']
          )
        end
      end

      it 'should return data points' do
        lines = @data.split("\n")
        assert_equal 'proc.net.bytes 1305211753 563002.2 iface=eth0 host=i-00000106', lines.first
      end
    end

    describe :png do
      before do
        VCR.use_cassette 'query_png', :record => :new_episodes do
          @data = @client.query(
            :format => 'png',
            :start  => Time.new(2011,5,12,9,44,29),
            :m      => ['sum:rate:proc.net.bytes', 'sum:rate:proc.stat.cpu']
          )
        end
      end

      it 'should return data points' do
        lines = @data.split("\n")
        assert_equal "\x89PNG\r", lines.first
      end
    end
  end

  describe :query_params do
    before do
      @hash = {
        :json  => true,
        :start => '2h-ago',
        :m     => ['sum:rate:proc.net.bytes', 'sum:rate:proc.stat.cpu']
      }
    end

    it 'should convert to query params when using an array' do
      assert_equal 'json=true&start=2h-ago&m=sum:rate:proc.net.bytes&m=sum:rate:proc.stat.cpu', @client.query_params(@hash)
    end

    it 'should be empty' do
      assert_equal '', @client.query_params({})
    end

    it 'should accept required parameters' do
      assert_equal 'json=true&start=2h-ago&m=sum:rate:proc.net.bytes&m=sum:rate:proc.stat.cpu', @client.query_params(@hash, [:start, 'm'])
    end

    it 'should raise an argument exception if requirements are not met' do
      assert_raises ArgumentError do
        @client.query_params(@hash, [:required])
      end
    end
  end
end
