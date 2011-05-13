module Continuum
  # Create an instance of the client to interface with the OpenTSDB API (http://opentsdb.net/http-api.html)
  class Client
    # Create an connection to a specific OpenTSDB instance
    #
    # *Params:*
    #
    # * host is the host IP (defaults to localhost)
    # * port is the host's port (defaults to 4242)
    #
    # *Returns:*
    #
    # A client to play with
    def initialize host = '127.0.0.1', port = 4242
      @client = Hugs::Client.new(
        :host   => host,
        :port   => port,
        :scheme => 'http',
        :type   => :none
      )
    end

    # Lists the supported aggregators by this instance
    #
    # *Returns:*
    #
    # An array of aggregators.
    def aggregators
      response = @client.get '/aggregators?json=true'
      JSON.parse response.body
    end

    # Lists an array of log lines. By default, OpenTSDB returns 1024 lines.
    # You can't modify that number via the API.
    #
    # *Returns:*
    #
    # An array of log lines.
    def logs
      response = @client.get '/logs?json=true'
      JSON.parse response.body
    end

    # Queries the instance for a graph. 3 (useful) formats are supported:
    #
    # * ASCII returns data that is suitable for graphing or otherwise interpreting on the client
    # * JSON returns meta data for the query
    # * PNG returns a PNG image you can render on the client
    #
    #
    # Params (See http://opentsdb.net/http-api.html#/q_Parameters for more information):
    #
    #
    # options a hash which may include the following keys:
    #
    # * format (one of json, ascii, png), defaults to json.
    # * start	The query's start date. (required)
    # * end	The query's end date.
    # * m	The query itself. (required, may be an array)
    # * o	Rendering options.
    # * wxh	The dimensions of the graph.
    # * yrange	The range of the left Y axis.
    # * y2range	The range of the right Y axis.
    # * ylabel	Label for the left Y axis.
    # * y2label	Label for the right Y axis.
    # * yformat	Format string for the left Y axis.
    # * y2format	Format string for the right Y axis.
    # * ylog	Enables log scale for the left Y axis.
    # * y2log	Enables log scale for the right Y axis.
    # * key	Options for the key (legend) of the graph.
    # * nokey	Removes the key (legend) from the graph.
    # * nocache	Forces TSD to ignore cache and fetch results from HBase.
    #
    # The syntax for metrics (m) (square brackets indicate an optional part):
    #
    # AGG:[interval-AGG:][rate:]metric[{tag1=value1[,tag2=value2...]}]
    def query options = {}
      format = options.delete(:format) || options.delete('format') || 'json'
      options[format.to_sym] = true
      params   = query_params(options, [:start, :m])
      response = @client.get "/q?#{params}"

      if format.to_sym == :json
        JSON.parse response.body
      else
        response.body
      end
    end

    # Stats about the OpenTSDB server itself.
    #
    # Returns:
    # An array of stats.
    def stats
      response = @client.get '/stats?json'
      JSON.parse response.body
    end

    # Returns suggestions for metric or tag names.
    #
    # Params:
    # * query: the string to search for
    # * type: the type of item to search for (defaults to metrics)
    # Type can be one of the following:
    # * metrics: Provide suggestions for metric names.
    # * tagk: Provide suggestions for tag names.
    # * tagv: Provide suggestions for tag values.
    #
    # Returns:
    # An array of suggestions
    def suggest query, type = 'metrics'
      response = @client.get "/suggest?q=#{query}&type=#{type}"
      JSON.parse response.body
    end

    # Returns the version of OpenTSDB
    #
    # Returns
    # An array with the version information
    def version
      response = @client.get '/version?json'
      JSON.parse response.body
    end

    # Parses a query param hash into a query string as expected by OpenTSDB
    # *Params:*
    # * params the parameters to parse into a query string
    # * requirements: any required parameters
    # *Returns:*
    # A query string
    # Raises:
    # ArgumentError if a required parameter is missing
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
          v = v.strftime('%Y/%m/%d-%H:%M:%S') if v.respond_to? :strftime
          query << "#{k}=#{v}"
        end
      end
      query.join '&'
    end
  end
end
