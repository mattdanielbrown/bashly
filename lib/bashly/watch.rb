require "listen"

module Bashly
  # File system watcher - an ergonomic wrapper around the Listen gem
  class Watch
    attr_reader :globs, :options

    DEFAULT_OPTIONS = {
      force_polling: true,
      latency: 1.0,
    }.freeze

    def initialize(*globs, **options)
      @options = DEFAULT_OPTIONS.merge(options).freeze
      @globs   = globs.empty? ? ['.'] : globs
    end

    def on_change(&block)
      start(&block)
      wait
    ensure
      stop
    end

  private

    def build_listener(&block)
      listen.to(*globs, **options) do |modified, added, removed|
        block.call changes(modified, added, removed)
      end
    end

    def start(&block)
      raise ArgumentError, "block required" unless block

      @listener = build_listener(&block)
      @listener.start
    end

    def stop
      @listener&.stop
      @listener = nil
    end

    def changes(modified, added, removed)
      { modified:, added:, removed: }
    end

    def listen = Listen
    def wait = sleep
  end
end
