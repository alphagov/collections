class FetchCoronavirusStatisticsService
  Statistics = Struct.new(:cumulative_vaccinations,
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
    statistics = Rails.cache.fetch(
      "coronavirus_statistics",
      expires_in: 5.minutes,
      race_condition_ttl: 30.seconds,
    ) { request_statistics }

    Statistics.new(statistics) unless statistics.empty?
  rescue StandardError => e
    Rails.logger.warn("Failed to load coronavirus statistics: #{e}")
    GovukError.notify(e) unless e.is_a?(Faraday::TimeoutError)
    nil
  end

  private_class_method :new

private

  def request_statistics
    connection = Faraday.new("https://coronavirus.data.gov.uk") do |f|
      f.response(:raise_error)
      f.options.timeout = 1
    end

    response = connection.get do |request|
      request.url("/api/v1/data", {
        filters: "areaName=United Kingdom;areaType=overview",
        structure: {
          "date" => "date",
          "cumulativeVaccinations" => "cumPeopleVaccinatedFirstDoseByPublishDate",
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

    parsed
  end
end
