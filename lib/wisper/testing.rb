require "wisper/testing/version"
require "wisper/testing/fake_broadcaster"
require "wisper/testing/inline_broadcaster"

module Wisper
  class Testing
    # Sets all broadcasters to FakeBroadcaster which does not broadcast any
    # events to the subscriber.
    #
    # @return self
    #
    def self.fake!
      store_original_broadcasters
      Wisper.configuration.broadcasters.keys.each do |key, broadcaster|
        Wisper.configuration.broadcasters[key] = FakeBroadcaster.new
      end
      is_enabled
      self
    end

    # Sets all broadcasters to FakeBroadcaster which does not broadcast any
    # events to the subscriber, for the duration of the block
    #
    # @return self
    #
    def self.fake
      fake!
      yield
      restore!
      self
    end

    # Sets all broadcasters to InlineBroadcaster which broadcasts event
    #  to the subscriber synchronously.
    #
    #  @return self
    #
    def self.inline!
      store_original_broadcasters
      Wisper.configuration.broadcasters.keys.each do |key, broadcaster|
        Wisper.configuration.broadcasters[key] = InlineBroadcaster.new
      end
      is_enabled
      self
    end

    # Restores the original broadcasters configuration
    #
    # @return self
    #
    def self.restore!
      if enabled?
        Wisper.configuration.broadcasters.clear
        original_broadcasters.each do |key, broadcaster|
          Wisper.configuration.broadcasters[key] = broadcaster
        end
        is_not_enabled
      end
      self
    end

    # Returns true when either fake! or inline! having been invoked and restore!
    # has not subsequently been invoked.
    #
    # @return Boolean
    #
    def self.enabled?
      !!@enabled
    end

    # Forget the original broadcaster configuration.
    #
    # This is only used in the specs of Wisper::Testing to get clean state.
    #
    # @api private
    #
    def self._forget
      return unless original_broadcasters?
      @enabled = false
      @original_broadcasters = nil
    end

    private

    def self.is_enabled
      @enabled = true
    end

    def self.is_not_enabled
      @enabled = false
    end

    def self.original_broadcasters
      @original_broadcasters
    end

    def self.store_original_broadcasters
      @original_broadcasters = Wisper.configuration.broadcasters.to_h.dup
    end

    def self.original_broadcasters?
      !!original_broadcasters
    end
  end
end
