# frozen_string_literal: true

ENV["RACK_ENV"] = "test"

require "bario/web"
require "rack/test"

RSpec.describe Bario::Web do
  include Rack::Test::Methods

  def app
    described_class
  end

  let(:bar) do
    bar = Bario::Bar.create
    bar.add_bar
    bar
  end

  describe "GET /" do
    it "success response" do
      bar1 = Bario::Bar.create
      bar1.add_bar

      get "/"
      expect(last_response).to be_ok
    end
  end

  describe "POST /bars-delete-all" do
    before do
      bar
      post "/bars-delete-all"
    end

    it "delete all bars" do
      expect(Bario::Bar.all.count).to eq(0)
    end

    it "redirect to /" do
      follow_redirect!
    end
  end

  describe "POST /bars-delete/:id" do
    before do
      bar
      post "/bars-delete/#{bar.id}"
    end

    it "delete bar" do
      expect(Bario::Bar.find(bar.id)).to be_nil
    end

    it "redirect to /" do
      follow_redirect!
    end
  end
end
