class PopularTasks
  CACHE_EXPIRATION = 24.hours # Set the cache expiration time

  def initialize; end

  def client
    @client ||= Bigquery.build
  end

  def fetch_data(browse_page, date: Date.yesterday)
    @fetch_data = client
    @date = date.strftime("%Y-%m-%d")

    # Define cache keys for the specific browse page
    cache_key = "popular_tasks_#{browse_page}_#{@date}"

    Rails.cache.fetch(cache_key, expires_in: CACHE_EXPIRATION) do
      # If cache is empty, this block is executed
      query = <<~SQL
        WITH cte1 as (SELECT
        event_date,
        event_name,
        search_term,
        cleaned_page_location,
        cleaned_page_referrer,
        link_url,
        count(event_name) as click,

        FROM `ga4-analytics-352613.flattened_dataset.flattened_daily_ga_data_*`
        WHERE _TABLE_SUFFIX = FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 2 DAY))
        -- WHERE _table_suffix IN ('20240708', '20240709','20240710','20240711','20240712','20240713','20240714')
        group by 1,2,3,4,5,6),

        CTE2 as (SELECT
        event_date,
        sum(click) as clicks,
        cleaned_page_referrer as BrowsePage,
        search_term,
        ROW_NUMBER() OVER(PARTITION BY cleaned_page_referrer ORDER BY click DESC) Rank,
        link_url as SearchDestPage
        FROM cte1
        WHERE event_name = 'select_item'
        AND cleaned_page_referrer = '#{browse_page}'
        AND cleaned_page_location = '/search/all'
        group by click,event_date,cleaned_page_referrer,search_term,link_url
        order by cleaned_page_referrer,Rank asc)

        SELECT
        *
        FROM CTE2
        WHERE Rank <6
      SQL

      data = @fetch_data.query(query).all
      @results = data.map do |row|
        {
          url: row[:SearchDestPage],     # Using SearchDestPage as the link URL
          browse_page: row[:BrowsePage], # Using BrowsePage as the L1 browse
          rank: row[:Rank],              # Rank to order the links
        }
      end
      @results.sort_by { |link| link[:rank] } # Order the links by their rank
    end
  end
end
