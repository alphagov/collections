class WorldLocationNewsController < ApplicationController
  around_action :switch_locale
  enable_request_formats show: :atom

  def show
    path = request.path.gsub(".atom", "")
    @world_location_news = WorldLocationNews.find!(path)

    respond_to do |format|
      format.html do
        setup_content_item_and_navigation_helpers(@world_location_news)
      end

      format.atom do
        results = FeedContent.new(filter_world_locations: params[:name]).results(10)
        items = results.map { |result| FeedEntryPresenter.new(result) }

        render "feeds/feed", locals: { items:, root_url: Plek.new.website_root + path, title: "#{@world_location_news.title} - Activity on GOV.UK" }
      end
    end
  end
end
