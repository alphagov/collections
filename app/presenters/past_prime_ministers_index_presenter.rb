class PastPrimeMinistersIndexPresenter
  def initialize(past_prime_ministers)
    @sorted_prime_ministers_with_start_dates = sorted_prime_ministers_with_start_dates(past_prime_ministers)
  end

  def prime_minsters_between(start_date, end_date)
    @sorted_prime_ministers_with_start_dates.filter_map { |data, earliest_start_date|
      [data["title"], formatted_data(data)] if earliest_start_date.between?(start_date, end_date)
    }.to_h
  end

  def formatted_data(pm_data)
    image_object = pm_data["image"] || pm_data.dig("links", "person", 0, "details", "image")
    {
      href: pm_data["base_path"],
      image_src: image_object["url"],
      image_alt_text: image_object["alt_text"],
      heading_text: pm_data["title"],
      service: dates_in_service(dates_data(pm_data), pm_data.dig("details", "political_party")),
    }
  end

private

  def dates_in_service(dates_object, political_party)
    dates = dates_object.sort_by { |d| -d["start_year"] }.map { |d| "#{d['start_year']} to #{d['end_year']}" }
    political_party ? dates.map { |date_string| "#{political_party} #{date_string}" } : dates
  end

  def sorted_prime_ministers_with_start_dates(past_prime_ministers)
    past_prime_ministers.map { |pm_data| [pm_data, earliest_start_date(dates_data(pm_data))] }
                        .sort_by { |_data, earliest_start_date| -earliest_start_date }
  end

  def dates_data(prime_minister)
    prime_minister["dates_in_office"] || prime_minister.dig("details", "dates_in_office")
  end

  def earliest_start_date(dates_in_office_object)
    dates_in_office_object.map { |date_in_office| date_in_office["start_year"] }.max
  end
end
