# frozen_string_literal: true

require "sinatra"
require "camel_race"

module CamelRace
  # Sinatra app to provide a simple dashboard
  class Web < Sinatra::Base
    set :public_folder, File.dirname(__FILE__) + "/web/public"
    set :views, settings.root + "/web/views"

    helpers do
      def partial(page, options = {})
        erb page, options.merge!(layout: false)
      end
    end

    get "/" do
      erb :index
    end

    post "/tracks-delete/:id" do
      track = CamelRace::Track.find(params[:id])
      track.delete! if track
      redirect to("/")
    end
  end
end
