class PopularTasks
  NUMBER_OF_TASKS_TO_DISPLAY = 3

  def initialize(browse_page, date)
    @browse_page = browse_page
    @date = date
  end

  attr_reader :browse_page, :date

  def formatted_links
    highest_ranking_links.map do |row|
      {
        url: row[:link_url],
        title: row[:page_title],
      }
    end
  end

private

  def highest_ranking_links
    raw_data
      .sort_by { |link| link[:rank] }
      .first(NUMBER_OF_TASKS_TO_DISPLAY)
  end

  def raw_data
    data_service.popular_task_data(browse_page, date)
  end

  def data_service
    @data_service ||= PopularTasks::DataFetcher.new
  end
end
