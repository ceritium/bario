# frozen_string_literal: true

RSpec.describe Bario::Track do
  subject(:track) { described_class.create("foo") }

  before do
    Ohm.flush
  end

  describe ".new" do
    it "is not public" do
      expect do
        described_class.new
      end.to raise_error(NoMethodError)
    end
  end

  describe ".all" do
    it "returns a empty array" do
      expect(described_class.all).to eq([])
    end

    it "returns an array with the tracks" do
      track1 = described_class.create("foo")
      track2 = described_class.create("bar")

      expect(described_class.all.map(&:id)).to eql([track1, track2].map(&:id))
    end
  end

  describe ".create" do
    describe "with default values" do
      it { expect(track.name).to eq("foo") }
      it { expect(track.id).not_to be_nil }
      it { expect(track.total).to eq(100) }
      it { expect(track.current).to eq(0) }
      it { expect(track.root).to be true }
    end

    describe "with custom values" do
      subject(:track) { described_class.create("foo", total: 42, root: false) }

      it { expect(track.total).to eq(42) }
      it { expect(track.root).to be false }
    end
  end

  describe "#find" do
    it "return nil if not found" do
      expect(described_class.find(42)).to be_nil
    end

    it "return the track" do
      track_id = described_class.create("foo").id
      track = described_class.find(track_id)
      expect(track.id).to eq(track_id)
    end
  end

  describe "#current" do
    it "with negative internal value" do
      track.decrement!
      expect(track.current).to eq(0)
    end

    it "with internal value bigger than total" do
      track.total = 10
      track.increment!(100)
      expect(track.current).to eq(10)
    end
  end

  describe "#total" do
    it "with negative value" do
      track.total = -10
      expect(track.total).to eq(0)
    end
  end

  it "#total=" do
    track.total = 10
    expect(track.total).to eq(10)
  end

  describe "#increment!" do
    it "without params" do
      track.increment!
      expect(track.current).to eq(1)
    end

    it "with positive value" do
      track.increment!(10)
      expect(track.current).to eq(10)
    end

    it "with negative value" do
      track.increment!(10)
      track.increment!(-1)
      expect(track.current).to eq(9)
    end
  end

  describe "#decrement!" do
    before do
      track.increment!(50)
    end

    it "with positive value" do
      track.decrement!(10)
      expect(track.current).to eq(40)
    end

    it "with negative value" do
      track.decrement!(-10)
      expect(track.current).to eq(60)
    end
  end

  describe "#percent" do
    it "with total 0, current 0" do
      track.total = 0
      expect(track.percent.nan?).to eq(true)
    end

    it "with total non 0, current 0" do
      track.total = 10
      expect(track.percent).to eq(0)
    end

    it "with total non 0, current non 0" do
      track.total = 10
      track.increment!

      expect(track.percent).to eq(10.0)
    end
  end

  it "#inspect" do
    expect(track.inspect).to match(/Bario::Track:/)
  end

  describe "#add_track" do
    let!(:new_track) { track.add_track("bar") }

    it "add" do
      expect(track.tracks.count).to eq(1)
    end

    it "new track should root" do
      expect(described_class.all.map(&:id)).not_to include(new_track.id)
    end

    it "new track, total default is 100" do
      expect(new_track.total).to eq(100)
    end
  end

  describe "#delete" do
    it "remove from db" do
      track.delete!
      expect(described_class.find(track.id)).to be_nil
    end

    it "remove child track" do
      new_track = track.add_track("bar")
      new_track.delete!
      expect(track.tracks.count).to eq(0)
    end
  end
end
