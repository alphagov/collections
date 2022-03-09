module RecruitmentBannerHelper
  STUDY_URLS_FOR_TOPICS = {
    "/browse/business" => "https://GDSUserResearch.optimalworkshop.com/treejack/lb5eu75l",
    "/browse/tax" => "https://GDSUserResearch.optimalworkshop.com/treejack/lb5eu75l",
    "/browse/employing-people" => "https://gdsuserresearch.optimalworkshop.com/treejack/724268fr-1",
  }.freeze

  def show_banner?(path)
    STUDY_URLS_FOR_TOPICS.keys.any? { |topic| path.starts_with?(topic) }
  end

  def study_url_for(topic)
    parent_topic = topic.rpartition("/").first
    STUDY_URLS_FOR_TOPICS[parent_topic]
  end
end
