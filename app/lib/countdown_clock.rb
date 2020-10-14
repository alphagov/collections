class CountdownClock
  END_OF_TRANSITION_PERIOD = Date.new(2021, 1, 1)

  def days_left
    (END_OF_TRANSITION_PERIOD - today_in_london).to_i
  end

  def show?
    days_left.positive?
  end

  def days_text
    if days_left == 1
      I18n.t("transition_landing_page.countdown_day_to_go")
    else
      I18n.t("transition_landing_page.countdown_days_to_go")
    end
  end

private

  def today_in_london
    Time.zone.now.utc.to_date
  end
end
