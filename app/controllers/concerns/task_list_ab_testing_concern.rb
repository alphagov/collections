module TaskListAbTestingConcern
  def task_list_ab_test
    @task_list_ab_test ||= begin
      ab_test_request = TaskListAbTestRequest.new(request)
      ab_test_request.set_response_vary_header(response)
      ab_test_request
    end
  end

  def task_list_ab_variant
    task_list_ab_test.ab_test.requested_variant(request.headers)
  end

  def task_list_ab_response
    task_list_ab_variant.configure_response(response)
  end
end
