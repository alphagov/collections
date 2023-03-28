class PastPrimeMinistersIndex < HistoricAppointmentsIndex
  def all_prime_ministers
    prime_ministers_with_historical_accounts + prime_ministers_without_historical_accounts
  end

  def self.find!(base_path)
    content_item = ContentItem.find!(base_path)
    new(content_item)
  end

private

  def prime_ministers_with_historical_accounts
    @content_item.content_item_data.dig("links", "historical_accounts")
  end

  def prime_ministers_without_historical_accounts
    @content_item.content_item_data.dig("details", "appointments_without_historical_accounts")
  end
end
