module CoronavirusTimelineNationsHelper
  def show_timeline_nations?(timeline_list)
    timeline_list.any? { |item| item["national_applicability"] }
  end
end
