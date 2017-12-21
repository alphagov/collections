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

  def show_tasklist_link?(list_title)
    requested_variant.variant?('B') &&
      list_title == 'Popular services' && page_is_under_test?
  end

  def show_divorce_related_tasklists?(list_title)
    requested_variant.variant?('B') &&
      list_title == 'Getting separated or divorced' && page_is_under_test?
  end

  def hide_list_item_link?(list_item)
    base_path = '/separation-divorce'

    list_item.base_path == base_path &&
      requested_variant.variant?('B')
  end

  def page_is_under_test?
    [
      "/browse/driving/learning-to-drive",
      "/browse/driving/learning-to-drive.json",
      "/browse/driving/driving-licences",
      "/browse/driving/driving-licences.json",
      "/browse/births-deaths-marriages/marriage-divorce",
      "/browse/births-deaths-marriages/marriage-divorce.json",
    ].include? @request.path
  end

  def set_response_vary_header(response)
    requested_variant.configure_response(response)
  end
end
