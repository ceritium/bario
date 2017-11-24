# frozen_string_literal: true

ENV["RACK_ENV"] = "test"

require "bario/web"
require "rack/test"

RSpec.describe Bario::Web do
  include Rack::Test::Methods

  def app
    described_class
  end

  let(:track) do
    track = Bario::Track.create("foo")
    track.add_track("bar")
    track
  end

  describe "GET /" do
    it "success response" do
      track1 = Bario::Track.create("foo")
      track1.add_track("bar")

      get "/"
      expect(last_response).to be_ok
    end
  end

  describe "POST /tracks-delete-all" do
    before do
      track
      post "/tracks-delete-all"
    end

    it "delete all tracks" do
      expect(Bario::Track.all.count).to eq(0)
    end

    it "redirect to /" do
      follow_redirect!
    end
  end

  describe "POST /tracks-delete/:id" do
    before do
      track
      post "/tracks-delete/#{track.id}"
    end

    it "delete track" do
      expect(Bario::Track.find(track.id)).to be_nil
    end

    it "redirect to /" do
      follow_redirect!
    end
  end
end
