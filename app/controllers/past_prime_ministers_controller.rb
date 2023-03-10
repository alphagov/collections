class PastPrimeMinistersController < ApplicationController
  def show
    @past_prime_minister = PastPrimeMinister.find!(request.path)
    setup_content_item_and_navigation_helpers(@past_prime_minister)
  end

  def index
    @past_prime_ministers = PastPrimeMinistersIndex.find!(request.path)
    setup_content_item_and_navigation_helpers(@past_prime_ministers)
    @presenter = PastPrimeMinistersIndexPresenter.new(@past_prime_ministers.all_prime_ministers)
  end
end
