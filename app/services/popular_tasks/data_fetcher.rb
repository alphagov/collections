module PopularTasks
  class DataFetcher
    def initialize(data_source: Bigquery)
      @data_source = data_source
    end

    attr_reader :data_source

    def client
      @client ||= data_source.build
    end

    # These tables don't exist and are just for illustration:
    def sql_query(browse_page, raw_date)
      <<~SQL
        WITH CTE1 AS (
          SELECT *
          FROM `ga4-analytics-352613.browse-popular-tasks.#{browse_page}_*`
          WHERE _TABLE_SUFFIX = FORMAT_DATE('%Y%m%d', #{raw_date})
        )
        SELECT
          page_title AS title,
          link_url AS link,
          rank AS rank
        FROM CTE1
      SQL
    end

    def popular_task_data(page, date)
      todays_popular_tasks_query = sql_query(page, date)
      client.query(todays_popular_tasks_query).all
    end
  end
end
