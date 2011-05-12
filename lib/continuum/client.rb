module Continuum
  class Client
    def initialize host = '127.0.0.1', port = 4242
      @client = Hugs::Client.new(
        :host   => host,
        :port   => port,
        :scheme => 'http',
        :type   => :json
      )
    end

    def aggregators
      response = @client.get '/aggregators'
      response.body
    end

  end
end
