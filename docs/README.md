Ringflux
=========

An Adhearsion plugin providing integration with InfluxDB

Configuration
-------------

As with all Adhearsion plugins, type `rake config:show` to see the list of configuration options.

Usage
-----

```Ruby
data = {
  values: { active_calls: Adhearsion.active_calls.count },
  tags:   { environment: Adhearsion.environment, host: Adhearsion::Process.fqdn }
  # tags are optional
}

Ringflux.write_point "active_calls", data
```

See [InfluxDB Ruby gem](https://github.com/influxdata/influxdb-ruby) for more information.
