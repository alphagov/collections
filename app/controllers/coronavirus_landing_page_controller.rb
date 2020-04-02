class CoronavirusLandingPageController < ApplicationController
  skip_before_action :set_expiry
  before_action -> { set_expiry(5.minutes) }

  def show
    @content_item = content_item.to_hash
    breadcrumbs = [{ title: "Home", url: "/", is_page_parent: true }]
    render "show", locals: { breadcrumbs: breadcrumbs, details: presenter,
      special_announcement: special_announcement }
  end

  def business
    @content_item = content_item.to_hash
    breadcrumbs = [
      { title: "Home", url: "/" },
      { title: "Coronavirus (COVID-19)", url: "/coronavirus", is_page_parent: true },
    ]
    render "business", locals: {
      breadcrumbs: breadcrumbs,
      details: business_presenter,
    }
  end

private

  def content_item
    ContentItem.find!(request.path)
  end

  def presenter
    CoronavirusLandingPagePresenter.new(@content_item)
  end

  def special_announcement
    SpecialAnnouncementPresenter.new(@content_item)
  end

  def business_presenter
    BusinessSupportPagePresenter.new(@content_item)
  end
end
