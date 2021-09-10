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
                          :total_current_week_admissions,
                          :cases_percentage_change,
                          :admissions_percentage_change,
                          :total_cases_change,
                          :total_admissions_change,
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

    current_week_cases = data.first(7).map { |day_cases| day_cases["newPositiveTests"] }
    if current_week_cases.compact.size == 7
      parsed[:total_current_week_cases] = current_week_cases.inject(:+)
    end

    current_week_admissions = data.first(7).map { |day_cases| day_cases["hospitalAdmissions"] }
    if current_week_admissions && current_week_admissions.compact.size == 7
      parsed[:total_current_week_admissions] = current_week_admissions.inject(:+)
    end

    if data.size >= 13
      previous_week_cases = data[7..13].map { |day_cases| day_cases["newPositiveTests"] }
      if parsed[:total_current_week_cases] && previous_week_cases && previous_week_cases.compact.size == 7
        total_previous_week_cases = previous_week_cases.inject(:+)
        parsed[:total_cases_change] = parsed[:total_current_week_cases] - total_previous_week_cases
        parsed[:cases_percentage_change] = ((parsed[:total_current_week_cases] - total_previous_week_cases) / total_previous_week_cases.to_f) * 100
      end

      previous_week_admissions = data[7..13].map { |day_cases| day_cases["hospitalAdmissions"] }
      if parsed[:total_current_week_admissions] && previous_week_admissions && previous_week_admissions.compact.size == 7
        total_previous_week_admissions = previous_week_admissions.inject(:+)
        parsed[:total_admissions_change] = parsed[:total_current_week_admissions] - total_previous_week_admissions
        parsed[:admissions_percentage_change] = ((parsed[:total_current_week_admissions] - total_previous_week_admissions) / total_previous_week_admissions.to_f) * 100
      end
    end

    parsed
  end
end
