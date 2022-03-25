module RecruitmentBannerHelper
  STUDY_URL_ONE = "https://GDSUserResearch.optimalworkshop.com/treejack/s46554q1".freeze
  STUDY_URLS_FOR_TOPICS = {
    "/browse/business" => STUDY_URL_ONE,
    "/browse/tax" => STUDY_URL_ONE,
    "/browse/employing-people" => STUDY_URL_ONE,
  }.freeze

  def study_url_for(path)
    key = STUDY_URLS_FOR_TOPICS.keys.find { |topic| path.starts_with?(topic) }
    STUDY_URLS_FOR_TOPICS[key]
  end
end
