# frozen_string_literal: true

require "forwardable"
require "bario/inspector"

module Bario
  # Track encapsulate all the logic to create, list, find, delete and update
  # the progress bars
  class Track
    extend Forwardable
    include Inspector

    def_delegators :track, :id, :name, :root

    inspector :id, :name, :total, :current, :root

    DEFAULT_TOTAL = 100

    class << self
      def find(id)
        track = InternalTrack[id]
        track ? new(track) : nil
      end

      def all
        collection(InternalTrack.find(root: true))
      end

      def create(opts = {})
        opts[:total] ||= DEFAULT_TOTAL
        opts[:root] = true unless opts.key?(:root)

        track = InternalTrack.create(opts)

        parent = opts[:parent]
        parent.children.push(track) if parent
        new(track)
      end

      def collection(tracks)
        tracks.map { |item| new(item) }
      end
    end

    def initialize(track)
      @track = track
    end

    private_class_method :new

    def percent
      current / total.to_f * 100
    end

    def current
      [
        [0, track.current].max,
        total
      ].min
    end

    def total
      [0, track.total.to_i].max
    end

    def total=(val)
      track.total = val
    end

    def add_track(opts = {})
      opts[:total] ||= DEFAULT_TOTAL
      opts[:parent] = track
      opts[:root] = false
      Track.create(opts)
    end

    def tracks
      self.class.collection(track.children)
    end

    def increment(by = 1)
      track.increment(:current, by)
    end

    def decrement(by = 1)
      track.decrement(:current, by)
    end

    def delete
      parent = track.parent
      parent.children.delete(track) if parent
      track.delete
    end

    private

    attr_reader :track

    # Internal storage backed in redis for track
    class InternalTrack < Ohm::Model
      attribute :name
      index :name

      attribute :root
      index :root

      attribute :total
      attribute :current
      counter :current

      list :children, "Bario::Track::InternalTrack"
      reference :parent, "Bario::Track::InternalTrack"
    end

    private_constant :InternalTrack
  end
end
