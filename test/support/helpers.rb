class ActiveSupport::TestCase
  def build_ostruct_recursively(value)
    case value
    when Hash
      OpenStruct.new(value.transform_values { |v| build_ostruct_recursively(v) })
    when Array
      value.map { |v| build_ostruct_recursively(v) }
    else
      value
    end
  end

  def assert_includes_params(expected_params)
    search_results = {
      "results" => [
        {
          "title" => "Doc 1",
        },
        {
          "title" => "Doc 2",
        },
      ],
    }

    Services
      .search_api
      .stubs(:search)
      .with { |params| _(params).including?(expected_params) }
      .returns(search_results)

    results = yield

    assert_equal(results.count, 2)

    assert_equal(results.first.title, "Doc 1")
    assert_equal(results.last.title, "Doc 2")
  end
end
