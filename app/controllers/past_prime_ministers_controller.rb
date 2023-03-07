class PastPrimeMinistersController < ApplicationController
  def show
    @past_prime_minister = PastPrimeMinister.find!(request.path)
    setup_content_item_and_navigation_helpers(@past_prime_minister)
  end

  def index
    @content_item = {}
  end
end
