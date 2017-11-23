# frozen_string_literal: true

RSpec.describe Bario do
  it "has a version number" do
    expect(Bario::VERSION).not_to be nil
  end

  it "#redis_uri=" do
    uri = "redis://foo:43/bar"
    described_class.redis_uri = uri
    expect(described_class.redic.url).to eq(uri)
  end

  describe "#redic" do
    it "default redic" do
      expect(described_class.redic).not_to be nil
    end

    it "assign redic" do
      redic = Redic.new
      described_class.redic = redic

      expect(described_class.redic).to be(redic)
    end
  end
end
