class CountdownClock
  END_OF_TRANSITION_PERIOD = Date.new(2021, 1, 1)

  def days_left
    sprintf "%02d", days_left_integer
  end

  def show?
    days_left_integer.positive?
  end

  def days_text
    if days_left_integer == 1
      I18n.t("transition_landing_page.countdown_day_to_go")
    else
      I18n.t("transition_landing_page.countdown_days_to_go")
    end
  end

private

  def days_left_integer
    (END_OF_TRANSITION_PERIOD - today_in_london).to_i
  end

  def today_in_london
    Time.zone.today
  end
end
