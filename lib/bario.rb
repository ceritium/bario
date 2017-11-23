# frozen_string_literal: true

require "ohm"

require "bario/version"
require "bario/track"

# Main module of Bario
module Bario
  def self.redic
    Ohm.redis
  end

  def self.redis_uri=(uri)
    Ohm.redis = Redic.new(uri)
  end

  def self.redic=(redic)
    Ohm.redis = redic
  end
end
