module RecruitmentBannerHelpers
  TOPIC_TO_TEST = "/browse/visas-immigration".freeze

  def hide_banner?(path)
    !path.starts_with?(TOPIC_TO_TEST)
  end
end
