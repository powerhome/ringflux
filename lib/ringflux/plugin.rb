require 'influxdb'
require 'countdownlatch'

class Ringflux::Plugin < Adhearsion::Plugin
  mattr_reader :connection

  # Configure the connection information to your InfluxDB instance.
  config :ringflux do
    host        nil         , desc: 'Hostname/IP to the InfluxDB server'
    username    nil         , desc: 'InfluxDB username'
    password    nil         , desc: 'InfluxDB password'
    database    'adhearsion', desc: 'host where the message queue is running'
    async       true        , desc: 'Write metrics asynchronously'
  end

  run :ringflux, after: :punchblock do
    InfluxDB::Logging.logger = logger
    new.start
  end

  def start
    logger.info "Connecting to InfluxDB #{config.username}@#{config.host} with database #{config.database}"
    @@connection = InfluxDB::Client.new config.database, host: config.host, username: config.username, password: config.password, async: config.async
  end

  def self.write_point(*args)
    logger.debug "Sending data to  InfluxDB: #{args.inspect}"
    @@connection.write_point(*args)
  end

  private

  def config
    self.class.config
  end
end
