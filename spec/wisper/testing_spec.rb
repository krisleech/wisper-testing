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
  let(:publisher)  { publisher_class.new }
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

    describe 'when fake! or inline! have never been called' do
      it 'is a no-op' do
        default_broadcaster = double
        async_broadcaster = double

        Wisper.configuration.broadcaster(:default, default_broadcaster)
        Wisper.configuration.broadcaster(:async,   async_broadcaster)

        Wisper::Testing.restore!

        expect(Wisper.configuration.broadcasters[:default]).to eq default_broadcaster
        expect(Wisper.configuration.broadcasters[:async]).to eq async_broadcaster
      end
    end

    it 'returns self' do
      expect(Wisper::Testing.restore!).to eq Wisper::Testing
    end
  end

  describe '#enabled?' do
    it 'returns false' do
      expect(described_class.enabled?).to eq false
    end

    describe 'when faking' do
      it 'returns true' do
        described_class.fake!
        expect(described_class.enabled?).to eq true
      end

      describe 'and then restored' do
        it 'returns false' do
          described_class.fake!
          described_class.restore!
          expect(described_class.enabled?).to eq false
        end
      end
    end

    describe 'when inline' do
      it 'returns true' do
        described_class.inline!
        expect(described_class.enabled?).to eq true
      end

      describe 'and then restored' do
        it 'returns false' do
          described_class.inline!
          described_class.restore!
          expect(described_class.enabled?).to eq false
        end
      end
    end
  end
end
