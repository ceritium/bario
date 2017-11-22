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

      def url_path(*path_parts)
        [url_prefix, path_prefix, path_parts].join("/").squeeze("/")
      end

      alias_method :u, :url_path

      def path_prefix
        request.env["SCRIPT_NAME"]
      end

      # In the future it will be a configuration param
      def url_prefix
        nil
      end
    end

    get "/" do
      @tracks = CamelRace::Track.all
      erb :index
    end

    post "/tracks-delete-all" do
      CamelRace::Track.all.each(&:delete!)

      redirect to("/")
    end

    post "/tracks-delete/:id" do
      track = CamelRace::Track.find(params[:id])
      track.delete! if track
      redirect to("/")
    end
  end
end
