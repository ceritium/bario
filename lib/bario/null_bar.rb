# frozen_string_literal: true

require "bario/bar"

module Bario
  # Null version of Bar
  class NullBar
    def created_at
      Time.now.utc
    end

    def updated_at
      Time.now.utc
    end

    def name
      ""
    end

    def root
      false
    end

    def total
      0
    end

    def current
      0
    end

    def percent
      0.0
    end

    def bars
      []
    end

    def add_bar(_opts = {})
      self.class.new
    end

    private

    def method_missing(method, *args, &block)
      if respond_to?(method)
        nil
      else
        super
      end
    end

    def respond_to_missing?(method_name, _include_private = false)
      Bario::Bar.instance_methods.include?(method_name)
    end
  end
end
