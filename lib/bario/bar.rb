# frozen_string_literal: true

require "forwardable"
require "bario/inspector"
require "bario/null_bar"
require "bario/storage"

module Bario
  # Bar encapsulate all the logic to create, list, find, delete and update
  # the progress bars
  class Bar
    extend Forwardable
    include Inspector

    def_delegators :bar, :id, :name, :root

    inspector :id, :name, :total, :current, :root, :created_at, :updated_at

    DEFAULT_TOTAL = 100

    class << self
      def find(id)
        bar = Storage[id]
        bar ? new(bar) : nil
      end

      def get(id)
        bar = Storage[id]
        bar ? new(bar) : NullBar.new
      end

      def all
        collection(Storage.find(root: true))
      end

      def create(opts = {})
        opts[:total] ||= DEFAULT_TOTAL
        opts[:root] = true unless opts.key?(:root)

        bar = Storage.create(opts)

        parent = opts[:parent]
        parent.children.push(bar) if parent
        new(bar)
      end

      def collection(bars)
        bars.map { |item| new(item) }
      end
    end

    def initialize(bar)
      @bar = bar
    end

    private_class_method :new

    def created_at
      Time.at(bar.created_at.to_i).utc
    end

    def updated_at
      Time.at(bar.updated_at.to_i).utc
    end

    def percent
      current / total.to_f * 100
    end

    def current
      [
        [0, bar.current].max,
        total
      ].min
    end

    def total
      [0, bar.total.to_i].max
    end

    def total=(val)
      bar.total = val
    end

    def add_bar(opts = {})
      opts[:total] ||= DEFAULT_TOTAL
      opts[:parent] = bar
      opts[:root] = false
      Bar.create(opts)
    end

    def bars
      self.class.collection(bar.children)
    end

    def increment(by = 1)
      bar.increment(:current, by)
    end

    def decrement(by = 1)
      bar.decrement(:current, by)
    end

    def delete
      parent = bar.parent
      parent.children.delete(bar) if parent
      bar.delete
    end

    private

    attr_reader :bar
  end
end
