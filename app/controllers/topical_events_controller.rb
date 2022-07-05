class TopicalEventsController < ApplicationController
  enable_request_formats show: :atom

  def show
    path = topical_event_path(params[:name])
    @topical_event = TopicalEvent.find!(path)

    respond_to do |format|
      format.html do
        setup_content_item_and_navigation_helpers(@topical_event)
      end

      format.atom do
        results = FeedContent.new(filter_topical_events: params[:name]).results(10)
        items = results.map { |result| FeedEntryPresenter.new(result) }

        render "feeds/feed", locals: { items: items, root_url: Plek.new.website_root + path, title: "#{@topical_event.title} - Activity on GOV.UK" }
      end
    end
  end
end
