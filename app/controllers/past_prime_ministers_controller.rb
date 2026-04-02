class PastPrimeMinistersController < ApplicationController
  def index
    @index_page = PastPrimeMinistersIndex.find!(request)
    @presenter = PastPrimeMinistersIndexPresenter.new(@index_page.all_prime_ministers)
    setup_content_item_and_navigation_helpers(@index_page)
    render template: "historic_appointments/index"
  end

  def show
    @past_prime_minister = PastPrimeMinister.find!(request)
    setup_content_item_and_navigation_helpers(@past_prime_minister)
  end
end
