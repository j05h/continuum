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
      response = @client.get '/aggregators?json=true'
      response.body
    end

    def logs
      response = @client.get '/logs?json=true'
      response.body
    end

    # start	The query's start date. (required)
    # end	The query's end date.
    # m	The query itself. (required at least once)
    # o	Rendering options.
    # wxh	The dimensions of the graph.
    # yrange	The range of the left Y axis.
    # y2range	The range of the right Y axis.
    # ylabel	Label for the left Y axis.
    # y2label	Label for the right Y axis.
    # yformat	Format string for the left Y axis.
    # y2format	Format string for the right Y axis.
    # ylog	Enables log scale for the left Y axis.
    # y2log	Enables log scale for the right Y axis.
    # key	Options for the key (legend) of the graph.
    # nokey	Removes the key (legend) from the graph.
    # nocache	Forces TSD to ignore cache and fetch results from HBase.
    #
    # The syntax for metrics (m) (square brackets indicate an optional part):
    # AGG:[interval-AGG:][rate:]metric[{tag1=value1[,tag2=value2...]}]

    def query options = {}
      params   = query_params(options, [:start, :m])
      response = @client.get "/q?#{params}"
      response.body
    end

    def query_params params = {}, requirements = []
      query = []

      requirements.each do |req|
        unless params.keys.include?(req.to_sym) || params.keys.include?(req.to_s)
          raise ArgumentError.new("#{req} is a required parameter.")
        end
      end

      params.each_pair do |k,v|
        if v.respond_to? :each
          v.each do |subv|
            query << "#{k}=#{subv}"
          end
        else
          query << "#{k}=#{v}"
        end
      end
      query.join '&'
    end
  end
end
