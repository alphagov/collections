class FetchCoronavirusStatisticsService
  CACHE_KEY = "coronavirus_statistics".freeze

  Statistics = Struct.new(:cumulative_first_dose_vaccinations,
                          :cumulative_second_dose_vaccinations,
                          :percentage_first_vaccine,
                          :percentage_second_vaccine,
                          :cumulative_vaccinations_date,
                          :hospital_admissions,
                          :hospital_admissions_date,
                          :new_positive_tests,
                          :new_positive_tests_date,
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
          "cumulativeFirstDoseVaccinations" => "cumPeopleVaccinatedFirstDoseByPublishDate",
          "cumulativeSecondDoseVaccinations" => "cumPeopleVaccinatedSecondDoseByPublishDate",
          "percentageFirstVaccine" => "cumVaccinationFirstDoseUptakeByPublishDatePercentage",
          "percentageSecondVaccine" => "cumVaccinationSecondDoseUptakeByPublishDatePercentage",
          "hospitalAdmissions" => "newAdmissions",
          "newPositiveTests" => "newCasesByPublishDate",
        }.to_json,
      })
    end

    parse_response(response)
  end

  def parse_response(response)
    data = JSON.parse(response.body).fetch("data")
    parsed = {}

    parsed.merge!(latest_vaccinations(data))
    parsed.merge!(latest_admissions(data))
    parsed.merge!(latest_tests(data))

    parsed
  end

  def latest_vaccinations(data)
    latest_vaccinations = data.find do |d|
      d["cumulativeFirstDoseVaccinations"] &&
        d["cumulativeSecondDoseVaccinations"] &&
        d["percentageFirstVaccine"] &&
        d["percentageSecondVaccine"]
    end

    return {} unless latest_vaccinations

    {
      cumulative_first_dose_vaccinations: latest_vaccinations["cumulativeFirstDoseVaccinations"],
      cumulative_second_dose_vaccinations: latest_vaccinations["cumulativeSecondDoseVaccinations"],
      percentage_first_vaccine: latest_vaccinations["percentageFirstVaccine"],
      percentage_second_vaccine: latest_vaccinations["percentageSecondVaccine"],
      cumulative_vaccinations_date: Date.parse(latest_vaccinations["date"]),
    }
  end

  def latest_admissions(data)
    latest_admissions = data.find { |d| d["hospitalAdmissions"] }

    return {} unless latest_admissions

    {
      hospital_admissions: latest_admissions["hospitalAdmissions"],
      hospital_admissions_date: Date.parse(latest_admissions["date"]),
    }
  end

  def latest_tests(data)
    latest_tests = data.find { |d| d["newPositiveTests"] }

    return {} unless latest_tests

    {
      new_positive_tests: latest_tests["newPositiveTests"],
      new_positive_tests_date: Date.parse(latest_tests["date"]),
    }
  end
end
