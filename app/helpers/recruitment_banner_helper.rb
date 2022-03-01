module RecruitmentBannerHelper
  TOPICS = ["/browse/business", "/browse/tax"].freeze

  def show_banner?(path)
    path.starts_with?(TOPICS.first) || path.starts_with?(TOPICS.last)
  end
end
