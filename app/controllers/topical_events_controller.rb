class TopicalEventsController < ApplicationController
  enable_request_formats show: :atom

  def show
    path = topical_event_path(params[:name])
    @topical_event = TopicalEvent.find!(path)

    slimmer_template "gem_layout_no_emergency_banner" if @topical_event.slug == "her-majesty-queen-elizabeth-ii"

    respond_to do |format|
      format.html do
        setup_content_item_and_navigation_helpers(@topical_event)
      end

      format.atom do
        results = FeedContent.new(filter_topical_events: params[:name]).results(10)
        items = results.map { |result| FeedEntryPresenter.new(result) }

        render "feeds/feed", locals: { items:, root_url: Plek.new.website_root + path, title: "#{@topical_event.title} - Activity on GOV.UK" }
      end
    end
  end

  def array_of_links_to_organisations(organisations)
    organisations.map do |organisation|
      helpers.link_to organisation[:title], organisation[:base_path], class: "organisation-link govuk-link"
    end
  end

  helper_method :array_of_links_to_organisations
end
