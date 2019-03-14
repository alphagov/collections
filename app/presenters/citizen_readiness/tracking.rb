module CitizenReadiness
  module Tracking
    def featured_data_attributes
      {
        "track-category" => "navGridContentClicked",
        "track-action" => @index,
        "track-label" => title
      }
    end

    def sidebar_data_attributes
      {
        "track-category" => "sideNavTopics",
        "track-action" => title
      }
    end
  end
end
