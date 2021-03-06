require 'influxdb'
require 'countdownlatch'

class Ringflux::Plugin < Adhearsion::Plugin
  DEFAULT_OPTS = {}
  mattr_reader :connection

  # Configure the connection information to your InfluxDB instance.
  config :ringflux do
    host        nil         , desc: 'Hostname/IP to the InfluxDB server'
    port        8086        , desc: 'TCP port for InfluxDB server'
    username    nil         , desc: 'InfluxDB username'
    password    nil         , desc: 'InfluxDB password'
    database    'adhearsion', desc: 'host where the message queue is running'
    async       true        , desc: 'Asynchronously send data to InfluxDB', transform: ->(value) { value && value != "false" }
    use_ssl     nil         , desc: 'Connect to InfluxDB using SSL', transform: ->(value) { value && value != "false" }
    retries     3           , desc: 'Number of attempts to make with the InfluxDB client', transform: ->(value) { value.to_i }
    opts        DEFAULT_OPTS, desc: 'Options to pass to the InfluxDB client'
  end

  init :ringflux, after: :punchblock do
    InfluxDB::Logging.logger = logger
    new.configure
  end

  def configure
    logger.info "Configuring InfluxDB #{config.username}@#{config.host}:#{config.port} with database #{config.database}"
    @@connection = InfluxDB::Client.new(
      config.database,
      config.opts.merge(
        host: config.host,
        port: config.port,
        username: config.username,
        password: config.password,
        async: config.async,
        use_ssl: config.use_ssl,
        retry: config.retries
      )
    )
  end

  #
  # Write data to InfluxDB client
  # @overload write_point(series, data, precision = nil, retention_policy = nil, database = nil)
  #   @param [String] series The name of the series to which to write
  #   @param [Hash] data The hash of data to send in the payload
  #     * :values [Hash] values The hash of key value pairs for the series
  #     * :tags [Hash] tags Optional hash of tags for the data
  #     * :timestamp [Integer] timestamp Optional epoch timestamp for the data (InfluxDB will default to now)
  #   @param [String] precision Optional string for time precision
  #   @param [String] retention_policy Optional string for retention policy
  #   @param [String] database Optional string to override database
  #
  def self.write_point(*args)
    raise ArgumentError, "Cannot write empty values to series: #{args[0]}" if args[1][:values].empty?
    logger.debug "Sending data to InfluxDB: #{args.inspect}"
    @@connection.write_point(*args)
  end

  private

  def config
    self.class.config
  end
end
