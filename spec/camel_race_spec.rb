# frozen_string_literal: true

RSpec.describe CamelRace do
  it "has a version number" do
    expect(CamelRace::VERSION).not_to be nil
  end

  describe "#redis" do
    it "default redis" do
      expect(described_class.redis).not_to be nil
    end

    it "assign redis" do
      redis = Redic.new
      described_class.redis = redis

      expect(described_class.redis).to be(redis)
    end
  end
end
