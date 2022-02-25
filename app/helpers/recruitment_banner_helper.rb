module RecruitmentBannerHelpers
  TOPICS = ["/browse/business", "/browse/tax"].freeze

  def show_banner?(path)
    path.starts_with?(TOPICS.first) || path.starts_with?(TOPICS.last)
  end

  def hide_banner?(path)
    !show_banner?(path)
  end
end
