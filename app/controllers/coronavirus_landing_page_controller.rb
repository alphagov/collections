class CoronavirusLandingPageController < ApplicationController
  def show
    @full_width = true
    breadcrumbs = [{ title: t("shared.breadcrumbs_home"), url: "/", is_page_parent: true }]

    render "show",
           locals: {
             breadcrumbs:,
             details: presenter,
             special_announcement:,
           }
  end

private

  def content_item
    @content_item ||= ContentItem.find!(request.path)
  end

  def presenter
    @presenter ||= CoronavirusLandingPagePresenter.new(content_item.to_hash)
  end

  def special_announcement
    @special_announcement ||= SpecialAnnouncementPresenter.new(content_item.to_hash)
  end
end
