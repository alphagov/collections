class CoronavirusLandingPageController < ApplicationController
  slimmer_template "gem_layout_full_width"

  def show
    @statistics = FetchCoronavirusStatisticsService.call
    if @statistics
      set_expiry content_item.max_age, public_cache: content_item.public_cache
    else
      logger.warn "Serving /coronavirus without statistics"
      set_expiry 30.seconds
    end

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

private

  def set_slimmer_template
    set_gem_layout_full_width
  end

  def content_item
    @content_item ||= ContentItem.find!(request.path)
  end

  def presenter
    @presenter ||= CoronavirusLandingPagePresenter.new(content_item.to_hash, params[:nation])
  end

  def special_announcement
    @special_announcement ||= SpecialAnnouncementPresenter.new(content_item.to_hash)
  end
end
