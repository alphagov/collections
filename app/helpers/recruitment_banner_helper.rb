module RecruitmentBannerHelper
  TOPICS = ["/browse/business", "/browse/tax", "/browse/employing-people"].freeze

  def show_banner?(path)
    TOPICS.each do |topic|
      return true if path.starts_with?(topic)
    end

    false
  end
end
