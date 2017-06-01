require 'influxdb'
require 'countdownlatch'

class Ringflux::Plugin < Adhearsion::Plugin
  DEFAULT_OPTS = {
    async: true,
  }
  mattr_reader :connection

  # Configure the connection information to your InfluxDB instance.
  config :ringflux do
    host        nil         , desc: 'Hostname/IP to the InfluxDB server'
    username    nil         , desc: 'InfluxDB username'
    password    nil         , desc: 'InfluxDB password'
    database    'adhearsion', desc: 'host where the message queue is running'
    opts        DEFAULT_OPTS, desc: 'Options to pass to the InfluxDB client'
  end

  init :ringflux, after: :punchblock do
    InfluxDB::Logging.logger = logger
    new.configure
  end

  def configure
    logger.info "Configuring InfluxDB #{config.username}@#{config.host} with database #{config.database}"
    @@connection = InfluxDB::Client.new config.database, config.opts.merge(host: config.host, username: config.username, password: config.password)
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
