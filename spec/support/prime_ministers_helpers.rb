module PrimeMinistersHelpers
  def api_data_for_person_without_historical_account(name, image_src, start_years)
    {
      "title" => name,
      "image" => {
        "url" => image_src,
        "alt_text" => name,
      },
      "dates_in_office" => start_years.map { |start_year| { "start_year" => start_year, "end_year" => start_year + 1 } },
    }
  end

  def api_data_for_person_with_historical_account(name, slug, image_src, start_years, political_party)
    {
      "title" => name,
      "base_path" => "/government/history/past-prime-ministers/#{slug}",
      "details" => {
        "political_party" => political_party,
        "dates_in_office" => start_years.map { |start_year| { "start_year" => start_year, "end_year" => start_year + 1 } },
      },
      "links" => {
        "person" => [
          {
            "title" => name,
            "details" => {
              "image" => {
                "url" => image_src,
                "alt_text" => name,
              },
            },
          },
        ],
      },
    }
  end

  def past_pms_content_item(people_with_historic_accounts = [], people_without_historic_accounts = [])
    {
      "base_path" => "/government/history/past-prime-ministers",
      "title" => "Past Prime Ministers",
      "links" => {
        "historical_accounts" => people_with_historic_accounts,
      },
      "details" => {
        "appointments_without_historical_accounts" => people_without_historic_accounts,
      },
    }
  end
end
