require "wisper/testing/version"
require "wisper/testing/fake_broadcaster"

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

    # Restores the original broadcasters configuration
    #
    # @return self
    #
    def self.restore!
      Wisper.configuration.broadcasters.clear
      original_broadcasters.each do |key, broadcaster|
        Wisper.configuration.broadcasters[key] = broadcaster
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
      original_broadcasters.clear
    end

    private

    def self.original_broadcasters
      @original_broadcasters ||= []
    end

    def self.store_original_broadcasters
      @original_broadcasters = Wisper.configuration.broadcasters.to_h.dup
    end
  end
end
