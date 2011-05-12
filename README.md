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
  => ["min", "sum", "max", "avg"]

# Todo
  * The rest of the Read API
	* The write API

