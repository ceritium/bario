# frozen_string_literal: true

RSpec.describe Bario::NullBar do
  subject(:nullbar) { described_class.new }

  describe "attributes" do
    it { expect(nullbar.name).to eq "" }
    it { expect(nullbar.id).to be_nil }
    it { expect(nullbar.total).to eq 0 }
    it { expect(nullbar.current).to eq 0 }
    it { expect(nullbar.root).to be false }
    it { expect(nullbar.percent).to eq 0.0 }
    it { expect(nullbar.created_at).to be_a Time }
    it { expect(nullbar.updated_at).to be_a Time }
  end

  describe "#method_missing" do
    it "Bario::Bar not respond to that" do
      expect { nullbar.imposiblemethod }.to raise_error(NoMethodError)
    end
  end

  it "#total=" do
    nullbar.total = 10
    expect(nullbar.total).to eq(0)
  end

  describe "#increment" do
    it "without params" do
      nullbar.increment
    end

    it "with param" do
      nullbar.increment(10)
    end
  end

  describe "#decrement" do
    it "without params" do
      nullbar.decrement
    end

    it "with param" do
      nullbar.decrement(10)
    end
  end

  it "#inspect" do
    expect(nullbar.inspect).to match(/Bario::NullBar:/)
  end

  describe "#add_bar" do
    let!(:new_bar) { nullbar.add_bar }

    it "add" do
      expect(nullbar.bars.count).to eq(0)
    end

    it "new nullbar" do
      expect(new_bar).to be_a(described_class)
    end
  end

  it "#delete" do
    nullbar.delete
  end
end
