module Ringflux
  def self.write_point(*args)
    Plugin.write_point(*args)
  end
end

require "ringflux/version"
require "ringflux/plugin"
