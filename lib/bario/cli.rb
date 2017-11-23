# frozen_string_literal: true

module Bario
  # Common OptionParser options for binaries
  module CLI
    def self.common(opts)
      opts.separator ""
      opts.separator "Options:"

      redis_opts(opts)
      help_opts(opts)
      version_opts(opts)
    end

    def self.redis_opts(opts)
      opts.on("-r", "--redis [redis://localhost:6379/0]",
              "Redis connection URI") do |uri|
        Bario.redis_uri = uri
      end
    end

    def self.help_opts(opts)
      opts.on("-h", "--help", "Show this message") do
        puts opts.help
        exit
      end
    end

    def self.version_opts(opts)
      opts.on("--version", "Show version") do
        puts Bario::VERSION
        exit
      end
    end
  end
end
