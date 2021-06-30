require "active_model"

class CoronavirusLandingPageController < ApplicationController
  slimmer_template :gem_layout_full_width

  def show
    @statistics = FetchCoronavirusStatisticsService.call
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
end
