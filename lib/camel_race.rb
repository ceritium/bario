# frozen_string_literal: true

require "ohm"

require "camel_race/version"
require "camel_race/track"

# Main module of CamelRace
module CamelRace
  def self.redis
    Ohm.redis
  end

  def self.redis=(redis)
    Ohm.redis = redis
  end
end
