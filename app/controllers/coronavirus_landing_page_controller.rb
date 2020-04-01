class CoronavirusLandingPageController < ApplicationController
  skip_before_action :set_expiry
  before_action -> { set_expiry(5.minutes) }

  def show
    @content_item = content_item.to_hash
    breadcrumbs = [{ title: "Home", url: "/", is_page_parent: true }]
    render "show", locals: { breadcrumbs: breadcrumbs, details: presenter, campaign_cookie: campaign_cookie }
  end

private

  def content_item
    ContentItem.find!("/coronavirus")
  end

  def presenter
    CoronavirusLandingPagePresenter.new(content_item.to_hash)
  end

  def cookie_policy
    if cookies.has_key?("cookies_policy")
      JSON.parse(cookies["cookies_policy"])
    else
      {}
    end
  end

  def campaign_cookie
    cookie_policy["campaigns"]
  end
end
