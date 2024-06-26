class PopularTasks
  def initialize; end

  def self.find(*args, **kwargs)
    new.find(*args, **kwargs)
  end

  def find(date:, slug:, &block)
    fetch_data(date:)
      .lazy
      .map(&:stringify_keys)
      .map(&method(:append_labels))
      .each_slice(batch_size, &block)
  end

  def client
    @client ||= Bigquery.build
  end

private

  def append_labels(hash)
    hash.merge("process_name" => "popular_task")
  end

  def fetch_data(date:)
    @fetch_data = client
    @date = date.strftime("%Y-%m-%d")

    query = <<~SQL
      SELECT cleaned_page_location, COUNT (*) AS count
      FROM `ga4-analytics-352613.flattened_dataset.flattened_daily_ga_data_*`
      WHERE page_referrer = 'https://www.gov.uk/browse/benefits'
      AND cleaned_page_location LIKE '/browse/benefits%'
      AND `event_date` >= '20240504'
      AND `event_date` < '20240604'
      GROUP BY cleaned_page_location
      ORDER BY count DESC
      LIMIT 2
    SQL

    @fetch_data.query(query, params: { date: @date }).all
  end
end

# Query to get most visited page from benefits browse page
# Takes 26 secs to run in the bigquery UI
# query = <<~SQL
#   SELECT cleaned_page_location, COUNT (*) AS count
#   FROM `ga4-analytics-352613.flattened_dataset.flattened_daily_ga_data_*`
#   WHERE page_referrer = 'https://www.gov.uk/browse/benefits'
#   AND cleaned_page_location LIKE '/browse/benefits%'
#   AND `event_date` >= '20240504'
#   AND `event_date` < '20240604'
#   GROUP BY cleaned_page_location
#   ORDER BY count DESC
#   LIMIT 2
# SQL
