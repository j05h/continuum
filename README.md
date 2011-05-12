# Continuum
A Ruby gem which integrates with the OpenTSDB API

http://opentsdb.net/http-api.html

# About OpenTSDB
OpenTSDB is a distributed, scalable Time Series Database (TSDB) written on top of HBase. OpenTSDB was written to address a common need: store, index and serve metrics collected from computer systems (network gear, operating systems, applications) at a large scale, and make this data easily accessible and graphable.

# About Continuum
Continuum integrates with the OpenTSDB API so that Ruby Applications can access the metrics written to OpenTSDB instances. Support is planned for writing metrics into an OpenTSDB instance. So that you can easily integrate with Ruby applications.

# Usage

	> client = Continuum::Client.new '10.0.0.1', 4242
	> client.aggregators
  \=> ["min", "sum", "max", "avg"]

	> client.logs.first
	\=> "1305212010\tINFO\tNew I/O server boss #1 ([id: 0x7d8a8ce2, /0:0:0:0:0:0:0:0:4242])\tnet.opentsdb.tsd.ConnectionManager\t[id: 0x33f98d58, /10.0.0.2:63832 => /10.0.0.1:4242] CONNECTED: /10.0.0.2:63832"

	> client.query(
			:json  => true,
			:start => '2h-ago',
			:m     => ['sum:rate:proc.net.bytes', 'sum:rate:proc.stat.cpu']
		)
  \=> {"plotted"=>701, "points"=>1961, "etags"=>[["direction"], ["type"]], "timing"=>370}

# Todo
* The rest of the Read API
* The write API

