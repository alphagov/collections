require "active_model"

class CoronavirusLandingPageController < ApplicationController
  def show
    set_expiry 5.minutes

    @content_item = content_item.to_hash
    breadcrumbs = [{ title: "Home", url: "/", is_page_parent: true }]
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
    breadcrumbs = [{ title: "Home", url: "/" }]
    title = {
      text: @content_item.dig("details", "page_title") || @content_item["title"],
      context: {
        text: "Coronavirus (COVID-19)",
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
