require "wisper/testing/version"
require "wisper/testing/fake_broadcaster"

module Wisper
  class Testing
    def self.fake!
      Wisper.configuration.broadcasters.keys.each do |key, broadcaster|
        Wisper.configuration.broadcasters[key] = FakeBroadcaster.new
      end
    end
  end
end
