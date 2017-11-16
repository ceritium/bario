# frozen_string_literal: true

require "sinatra"
require "camel_race"

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
