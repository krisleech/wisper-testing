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
      self
    end

    # Restores the original broadcasters configuration
    #
    # @return self
    #
    def self.restore!
      if original_broadcasters?
        Wisper.configuration.broadcasters.clear
        original_broadcasters.each do |key, broadcaster|
          Wisper.configuration.broadcasters[key] = broadcaster
        end
      end
      self
    end

    # Forget the original broadcaster configuration.
    #
    # This is only used in the specs of Wisper::Testing to get clean state.
    #
    # @api private
    #
    def self._forget
      return unless original_broadcasters?
      @original_broadcasters = nil
    end

    private

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
