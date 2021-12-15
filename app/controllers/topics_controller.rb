class TopicsController < ApplicationController
  include RecruitmentBannerHelpers

  def index
    topic = Topic.find(request.path)
    setup_content_item_and_navigation_helpers(topic)

    render :index,
           locals: {
             topic: topic,
             navigation_page_type: "Topic Index",
           }
  end

  def show
    @hide_recruitment_banner = hide_banner?(request.path)

    topic = Topic.find(request.path)
    setup_content_item_and_navigation_helpers(topic)
    render :index,
           locals: {
             topic: topic,
             navigation_page_type: "First Level Topic",
           }
  end
end
