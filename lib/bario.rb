# frozen_string_literal: true

require "ohm"

require "bario/version"
require "bario/track"

# Main module of Bario
module Bario
  def self.redis
    Ohm.redis
  end

  def self.redis=(redis)
    Ohm.redis = redis
  end
end
