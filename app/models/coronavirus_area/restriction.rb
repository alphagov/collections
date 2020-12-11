class CoronavirusArea
  class Restriction
    attr_reader :alert_level, :start_time

    def initialize(attributes)
      @alert_level = attributes.fetch("alert_level")
      @start_time = Time.zone.parse(
        "#{attributes.fetch('start_date')} #{attributes.fetch('start_time')}"
      )
    end

    def tier_three?
      alert_level == 3
    end

    def tier_two?
      alert_level == 2
    end

    def tier_one?
      alert_level == 1
    end
  end
end
