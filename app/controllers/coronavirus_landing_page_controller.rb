require "active_model"

class CoronavirusLandingPageController < ApplicationController
  def show
    @statistics = FetchCoronavirusStatisticsService.call
    @timeline_nations_items = timeline_nations_items
    if @statistics
      set_expiry 5.minutes
    else
      logger.warn "Serving /coronavirus without statistics"
      set_expiry 30.seconds
    end

    @content_item = content_item.to_hash
    breadcrumbs = [{ title: t("shared.breadcrumbs_home"), url: "/", is_page_parent: true }]
    title = {
      text: presenter.page_header,
    }

    render "show",
           locals: {
             breadcrumbs: breadcrumbs,
             title: title,
             details: presenter,
             special_announcement: special_announcement,
           }
  end

  def hub
    set_expiry 5.minutes

    @content_item = content_item.to_hash
    breadcrumbs = [{ title: t("shared.breadcrumbs_home"), url: "/" }]
    title = {
      text: @content_item.dig("details", "page_title") || @content_item["title"],
      context: {
        text: t("coronavirus_landing_page.title"),
        href: "/coronavirus",
      },
    }

    render "hub",
           locals: {
             breadcrumbs: breadcrumbs,
             title: title,
             details: hub_presenter,
           }
  end

private

  def content_item
    @content_item ||= ContentItem.find!(request.path)
  end

  def presenter
    @presenter ||= CoronavirusLandingPagePresenter.new(@content_item)
  end

  def special_announcement
    @special_announcement ||= SpecialAnnouncementPresenter.new(@content_item)
  end

  def hub_presenter
    @hub_presenter ||= CoronavirusHubPresenter.new(@content_item)
  end

  def timeline_nations_items
    values = %w[england scotland northern_ireland wales]
    selected = values.include?(params[:timeline_nation]) ? params[:timeline_nation] : "england"

    items = []
    values.each do |value|
      items << {
        value: value,
        text: value.gsub("_", " ").titleize,
        checked: selected == value,
      }
    end

    items
  end
end
