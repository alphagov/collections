class CountdownClock
  END_OF_TRANSITION_PERIOD = Time.zone.local(2020, 12, 31, 23, 59)

  def days_left
    sprintf "%02d", days_left_until_deadline
  end

  def show?
    minutes_left_until_deadline >= 30
  end

  def days_text
    if days_left_until_deadline == 1
      I18n.t("transition_landing_page.countdown_day_to_go")
    else
      I18n.t("transition_landing_page.countdown_days_to_go")
    end
  end

private

  def days_left_until_deadline
    (minutes_left_until_deadline / 60 / 24).ceil
  end

  def minutes_left_until_deadline
    (seconds_left_until_deadline / 60)
  end

  def seconds_left_until_deadline
    END_OF_TRANSITION_PERIOD - now_in_london
  end

  def now_in_london
    Time.zone.now
  end
end
