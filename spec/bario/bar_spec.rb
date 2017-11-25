# frozen_string_literal: true

RSpec.describe Bario::Bar do
  subject(:bar) { described_class.create(name: "foo") }

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

    it "returns an array with the bars" do
      bar1 = described_class.create
      bar2 = described_class.create

      expect(described_class.all.map(&:id)).to eql([bar1, bar2].map(&:id))
    end
  end

  describe ".create" do
    describe "with default values" do
      it { expect(bar.name).to eq("foo") }
      it { expect(bar.id).not_to be_nil }
      it { expect(bar.total).to eq(100) }
      it { expect(bar.current).to eq(0) }
      it { expect(bar.root).to be true }
    end

    describe "with custom values" do
      subject(:bar) { described_class.create(total: 42, root: false) }

      it { expect(bar.total).to eq(42) }
      it { expect(bar.root).to be false }
    end
  end

  describe "#find" do
    it "return nil if not found" do
      expect(described_class.find(42)).to be_nil
    end

    it "return the bar" do
      bar_id = described_class.create.id
      bar = described_class.find(bar_id)
      expect(bar.id).to eq(bar_id)
    end
  end

  describe "#current" do
    it "with negative internal value" do
      bar.decrement
      expect(bar.current).to eq(0)
    end

    it "with internal value bigger than total" do
      bar.total = 10
      bar.increment(100)
      expect(bar.current).to eq(10)
    end
  end

  describe "#total" do
    it "with negative value" do
      bar.total = -10
      expect(bar.total).to eq(0)
    end
  end

  it "#total=" do
    bar.total = 10
    expect(bar.total).to eq(10)
  end

  describe "#increment" do
    it "without params" do
      bar.increment
      expect(bar.current).to eq(1)
    end

    it "with positive value" do
      bar.increment(10)
      expect(bar.current).to eq(10)
    end

    it "with negative value" do
      bar.increment(10)
      bar.increment(-1)
      expect(bar.current).to eq(9)
    end
  end

  describe "#decrement" do
    before do
      bar.increment(50)
    end

    it "with positive value" do
      bar.decrement(10)
      expect(bar.current).to eq(40)
    end

    it "with negative value" do
      bar.decrement(-10)
      expect(bar.current).to eq(60)
    end
  end

  describe "#percent" do
    it "with total 0, current 0" do
      bar.total = 0
      expect(bar.percent.nan?).to eq(true)
    end

    it "with total non 0, current 0" do
      bar.total = 10
      expect(bar.percent).to eq(0)
    end

    it "with total non 0, current non 0" do
      bar.total = 10
      bar.increment

      expect(bar.percent).to eq(10.0)
    end
  end

  it "#inspect" do
    expect(bar.inspect).to match(/Bario::Bar:/)
  end

  describe "#add_bar" do
    let!(:new_bar) { bar.add_bar }

    it "add" do
      expect(bar.bars.count).to eq(1)
    end

    it "new bar should not be root" do
      expect(described_class.all.map(&:id)).not_to include(new_bar.id)
    end

    it "new bar, total default is 100" do
      expect(new_bar.total).to eq(100)
    end
  end

  describe "#delete" do
    it "remove from db" do
      bar.delete
      expect(described_class.find(bar.id)).to be_nil
    end

    it "remove child bar" do
      new_bar = bar.add_bar
      new_bar.delete
      expect(bar.bars.count).to eq(0)
    end
  end
end
