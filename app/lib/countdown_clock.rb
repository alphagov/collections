class CountdownClock
  END_OF_TRANSITION_PERIOD = Date.new(2021, 1, 1)

  def days_left
    (END_OF_TRANSITION_PERIOD - today_in_london).to_i
  end

  def today_in_london
    Time.zone.now.utc.to_date
  end

  def show?
    days_left.positive?
  end

  def days_text
    days_left == 1 ? "day" : "days"
  end
end
