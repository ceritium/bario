# frozen_string_literal: true

require "sinatra"
require "bario"

module Bario
  # Sinatra app to provide a simple dashboard
  class Web < Sinatra::Base
    set :public_folder, File.dirname(__FILE__) + "/web/public"
    set :views, settings.root + "/web/views"

    helpers do
      def partial(page, options = {})
        options[:layout] = false
        erb page, options
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

      def delete_all_path
        url_path "/bars-delete-all"
      end

      def delete_bar_path(id)
        url_path "/bars-delete/#{id}"
      end
    end

    get "/" do
      @bars = Bario::Bar.all
      erb :index
    end

    post "/bars-delete-all" do
      Bario::Bar.all.each(&:delete)

      redirect to("/")
    end

    post "/bars-delete/:id" do
      bar = Bario::Bar.find(params[:id])
      bar&.delete
      redirect to("/")
    end
  end
end
