class FetchCoronavirusStatisticsService
  CACHE_KEY = "coronavirus_statistics".freeze

  Statistics = Struct.new(:cumulative_vaccinations,
                          :cumulative_vaccinations_date,
                          :hospital_admissions,
                          :hospital_admissions_date,
                          :new_positive_tests,
                          :new_positive_tests_date,
                          :percent_of_first_vaccine,
                          :percent_of_first_vaccine_date,
                          :percent_of_second_vaccine,
                          :percent_of_second_vaccine_date,
                          :total_current_week_cases,
                          keyword_init: true)

  def self.call
    new.call
  end

  def call
    # This API times out on occassion, so we'll keep a copy of our potentially
    # stale data to use as a backup
    backup_statistics = Rails.cache.fetch(CACHE_KEY)
    statistics = fetch_current_statistics || backup_statistics

    Statistics.new(statistics) if statistics && statistics.any?
  end

  private_class_method :new

private

  def fetch_current_statistics
    Rails.cache.fetch(CACHE_KEY, expires_in: 30.minutes, race_condition_ttl: 5.minutes) do
      request_statistics
    end
  rescue StandardError => e
    Rails.logger.warn("Failed to load coronavirus statistics: #{e}")
    intermittent_error = case e
                         when Faraday::TimeoutError, Faraday::ConnectionFailed
                           true
                         when Faraday::ServerError
                           [502, 504].include?(e.response_status)
                         end

    GovukError.notify(e) unless intermittent_error
    nil
  end

  def request_statistics
    connection = Faraday.new("https://coronavirus.data.gov.uk") do |f|
      f.response(:raise_error)
      f.options.timeout = 2
    end

    response = connection.get do |request|
      request.url("/api/v1/data", {
        filters: "areaName=United Kingdom;areaType=overview",
        structure: {
          "date" => "date",
          "cumulativeVaccinations" => "cumPeopleVaccinatedFirstDoseByPublishDate",
          "hospitalAdmissions" => "newAdmissions",
          "newPositiveTests" => "newCasesByPublishDate",
          "percentageFirstVaccine" => "cumVaccinationFirstDoseUptakeByPublishDatePercentage",
          "percentageSecondVaccine" => "cumVaccinationSecondDoseUptakeByPublishDatePercentage",
        }.to_json,
      })
    end

    parse_response(response)
  end

  def parse_response(response)
    data = JSON.parse(response.body).fetch("data")
    parsed = {}

    if (latest_vaccinations = data.find { |d| d["cumulativeVaccinations"] })
      parsed[:cumulative_vaccinations] = latest_vaccinations["cumulativeVaccinations"]
      parsed[:cumulative_vaccinations_date] = Date.parse(latest_vaccinations["date"])
    end

    if (latest_admissions = data.find { |d| d["hospitalAdmissions"] })
      parsed[:hospital_admissions] = latest_admissions["hospitalAdmissions"]
      parsed[:hospital_admissions_date] = Date.parse(latest_admissions["date"])
    end

    if (latest_tests = data.find { |d| d["newPositiveTests"] })
      parsed[:new_positive_tests] = latest_tests["newPositiveTests"]
      parsed[:new_positive_tests_date] = Date.parse(latest_tests["date"])
    end

    if (latest_first_dose_percentage = data.find { |d| d["percentageFirstVaccine"] })
      parsed[:percent_of_first_vaccine] = latest_first_dose_percentage["percentageFirstVaccine"]
      parsed[:percent_of_first_vaccine_date] = Date.parse(latest_tests["date"])
    end

    if (latest_second_dose_percentage = data.find { |d| d["percentageSecondVaccine"] })
      parsed[:percent_of_second_vaccine] = latest_second_dose_percentage["percentageSecondVaccine"]
      parsed[:percent_of_second_vaccine_date] = Date.parse(latest_tests["date"])
    end

    last_7_days_cases = data.first(7).map { |day_cases| day_cases["newPositiveTests"] }
    if last_7_days_cases.compact.size == 7
      parsed[:total_current_week_cases] = last_7_days_cases.inject(:+)
    end

    parsed
  end
end
