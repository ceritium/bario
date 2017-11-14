require "forwardable"
require "securerandom"

require "camel_race/version"
require "camel_race/inspector"
require "ohm"

module CamelRace

  def self.redis
    Ohm.redis
  end

  def self.redis=(redis)
    Ohm.redis = redis
  end

  class Track

    extend Forwardable
    include Inspector

    def_delegators :track, :id, :name, :total, :current

    inspector :id, :name, :total, :current

    class << self
      def find(name)
        track = InternalTrack.with(:name, name)
        track ? new(track) : nil
      end

      def all
        collection(InternalTrack.find(top: true))
      end

      def collection(tracks)
        tracks.map{|x| new(x)}
      end

      def create(name, total: 0, top: true, parent: nil)
        id =  SecureRandom.uuid
        track = InternalTrack.create(id: id, name: name, total: total, top: top)
        if parent
          parent.tracks.add(track)
        end
        new(track)
      end
    end

    def initialize(track)
      @_track = track
    end

    private_class_method :new

    def percent
      current / total.to_f * 100
    end

    def add_track(child_name, total: 0)
      Track.create("#{name}:#{child_name}", total: total, top: false, parent: track)
    end

    def tracks
      self.class.collection(track.tracks)
    end

    def increment!(by = 1)
      track.increment(:current, by)
    end

    def decrement!(by = 1)
      track.decrement(:current, by)
    end

    def delete!
      track.delete
    end

    private

    def track
      @_track
    end

    class InternalTrack < Ohm::Model

      attribute :id
      unique :id
      attribute :name
      index :name

      attribute :top
      index :top

      attribute :total
      counter :current

      set :tracks, "CamelRace::Track::InternalTrack"
    end

    private_constant :InternalTrack

  end
end
