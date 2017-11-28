# frozen_string_literal: true

module Bario
  # Internal storage backed in redis for bar
  class Storage < Ohm::Model
    attribute :name
    index :name

    attribute :root
    index :root

    attribute :total
    attribute :current
    counter :current

    list :children, "Bario::Storage"
    reference :parent, "Bario::Storage"

    # Extracted from ohm-contrib
    Timestamp = ->(time) { time && time.to_i.to_s }
    attribute :created_at, Timestamp
    attribute :updated_at, Timestamp

    class << self
      def time_now
        Time.now.utc.to_i
      end
    end

    def save
      time_now = self.class.time_now

      self.created_at = time_now if new?
      self.updated_at = time_now
      super
    end

    # Override increment update `updated_at` attribute
    # `decrement` call to `increment`.
    def increment(att, count = 1)
      time_now = self.class.time_now

      redis.queue("HINCRBY", key[:counters], att, count)
      redis.queue("HSET", key, "updated_at", time_now)

      self.updated_at = time_now
      redis.commit
    end
  end
end
