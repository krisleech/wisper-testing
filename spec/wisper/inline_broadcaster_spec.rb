require 'spec_helper'

describe Wisper::Testing::InlineBroadcaster do
  describe '#broadcast' do
    it 'invokes subscriber' do
      listener = double('Listener')
      event_name = 'foobar'
      expect(listener).to receive(event_name)
      subject.broadcast(listener, double, event_name, double)
    end
  end
end
