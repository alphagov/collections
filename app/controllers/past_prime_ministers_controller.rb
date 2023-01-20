class PastPrimeMinistersController < ApplicationController
  def show
    @past_prime_minister = PastPrimeMinister.find!(request.path)
    setup_content_item_and_navigation_helpers(@past_prime_minister)
  end

  helper_method :pm_dates_in_office

  def index
    @past_pms = PastPrimeMinistersIndex.find!("/government/history/past-prime-ministers")
    @recent_appointments = all_recent_pms.unshift(@past_pms.pms_without_historical_accounts).flatten(1)
    @twentieth_century_appointments = all_twentieth_century_pms
    @eighteenth_and_nineteenth_century_appointments = all_eighteenth_and_nineteenth_century_pms
    setup_content_item_and_navigation_helpers(@past_pms)
  end

  def pm_dates_in_office(appointment, political_party = nil)
    if @past_pms.pms_without_historical_accounts.include?(appointment)
      appointment["dates_in_office"].map do |d|
        {
          text: "#{d['start_year']} to #{d['end_year']}",
        }
      end
    else
      appointment.dig("details", "dates_in_office")
                 .map do |d|
        {
          text: "#{political_party} #{d['start_year']} to #{d['end_year']}",
        }
      end
    end
  end

private

  def all_recent_pms
    @past_pms.pms_with_historical_accounts.select { |pm| pm.dig("details", "dates_in_office").last["start_year"] > 2001 }
  end

  def all_twentieth_century_pms
    @past_pms.pms_with_historical_accounts.select { |pm| pm.dig("details", "dates_in_office").last["start_year"].between?(1901, 2000) }
  end

  def all_eighteenth_and_nineteenth_century_pms
    @past_pms.pms_with_historical_accounts.select { |pm| pm.dig("details", "dates_in_office").last["start_year"].between?(1701, 1900) }
  end
end
