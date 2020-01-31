module TransitionPeriodHelper
  SWITCHOVER_TIME = Time.zone.parse("2020-01-31 23:00:00").in_time_zone

  def time_based_intl
    if before_switchover_and_not_overridden?
      "brexit_landing_page"
    else
      "transition_landing_page"
    end
  end

private

  def before_switchover_and_not_overridden?
    before_switchover? && !override?
  end

  def before_switchover?
    Time.zone.now < SWITCHOVER_TIME
  end

  def override?
    return false unless File.exist?("/tmp/transition_override")

    param = request.params["transition_override"]
    !param.nil? && param == File.read("/tmp/transition_override")
  end
end
