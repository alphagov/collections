class TaskListAbTestRequest
  attr_accessor :requested_variant
  attr_reader :ab_test

  delegate :analytics_meta_tag, to: :requested_variant

  def initialize(request)
    @request = request
    dimension = Rails.application.config.task_list_ab_test_dimension

    @ab_test = GovukAbTesting::AbTest.new("TaskListBrowse", dimension: dimension)
    @requested_variant = @ab_test.requested_variant(request.headers)
  end

  def show_tasklist_link?(list_title, params)
    requested_variant.variant?('B') &&
      list_title == 'Popular services' &&
      (@request.path == '/browse/driving/learning-to-drive' ||
        params[:second_level_slug] == 'learning-to-drive')
  end

  def set_response_vary_header(response)
    requested_variant.configure_response(response)
  end
end
