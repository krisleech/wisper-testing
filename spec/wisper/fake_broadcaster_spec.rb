require 'spec_helper'

describe Wisper::Testing::FakeBroadcaster do
  describe '#broadcast' do
    it 'does not invoke subscriber' do
      listener = double('Listener')
      expect { subject.broadcast(listener, double, double, double) }.not_to raise_error # [1]
    end
  end
end

# [1] - raises if the double gets any message, which is what we want.
