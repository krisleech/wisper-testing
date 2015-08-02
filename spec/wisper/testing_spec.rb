require 'spec_helper'

describe Wisper::Testing do
  it 'has a version number' do
    expect(Wisper::Testing::VERSION).not_to be nil
  end

  before(:each) do
    Wisper.configuration.broadcasters.clear
    described_class._forget
  end

  let(:publisher_class) { Class.new { include Wisper::Publisher } }
  let(:publisher) { publisher_class.new }
  let(:subscriber) { double('Subscriber') }

  describe '#fake!' do
    it 'ensures listener does not receive events' do
      Wisper.configuration.broadcaster(:default, Wisper::Broadcasters::SendBroadcaster.new)

      described_class.fake!

      event_name = 'foobar'

      publisher.subscribe(subscriber)

      expect(subscriber).not_to receive(event_name)
      expect(subscriber).to respond_to(event_name)

      publisher.send(:broadcast, event_name)
    end

    it 'sets fake broadcaster for all broadcaster keys' do
      Wisper.configuration.broadcaster(:default, double)
      Wisper.configuration.broadcaster(:async,   double)

      described_class.fake!

      expect(Wisper.configuration.broadcasters[:default]).to an_instance_of(Wisper::Testing::FakeBroadcaster)
      expect(Wisper.configuration.broadcasters[:async]).to an_instance_of(Wisper::Testing::FakeBroadcaster)
    end

    it 'returns self' do
      expect(Wisper::Testing.fake!).to eq Wisper::Testing
    end
  end

  describe '#inline!' do
    it 'ensures all events are broadcast synchronously' do
      Wisper.configuration.broadcaster(:default, double.as_null_object)
      Wisper.configuration.broadcaster(:async,   double.as_null_object)

      described_class.inline!

      event_name = 'foobar'

      publisher.subscribe(subscriber)

      expect(subscriber).to receive(event_name)

      publisher.send(:broadcast, event_name)
    end

    it 'uses default broadcaster for all events' do
      Wisper.configuration.broadcaster(:default, double)
      Wisper.configuration.broadcaster(:async,   double)

      described_class.inline!

      expect(Wisper.configuration.broadcasters[:default]).to an_instance_of(Wisper::Testing::InlineBroadcaster)
      expect(Wisper.configuration.broadcasters[:async]).to an_instance_of(Wisper::Testing::InlineBroadcaster)
    end

    it 'returns self' do
      expect(Wisper::Testing.inline!).to eq Wisper::Testing
    end
  end

  describe '#restore!' do
    it 'restores all broadcasters' do
      default_broadcaster = double
      async_broadcaster = double

      Wisper.configuration.broadcaster(:default, default_broadcaster)
      Wisper.configuration.broadcaster(:async,   async_broadcaster)

      Wisper::Testing.fake!

      Wisper::Testing.restore!

      expect(Wisper.configuration.broadcasters[:default]).to eq default_broadcaster
      expect(Wisper.configuration.broadcasters[:async]).to eq async_broadcaster
    end

    it 'returns self' do
      expect(Wisper::Testing.restore!).to eq Wisper::Testing
    end
  end

  describe '#faking?' do
    describe 'when faking' do

    end

    describe 'when not faking' do

    end
  end

  describe 'when faking' do
    before { Testing::Wisper.fake! }


  end

  describe 'when inline' do

  end
end
