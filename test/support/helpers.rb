class ActiveSupport::TestCase
  def build_ostruct_recursively(value)
    case value
    when Hash
      OpenStruct.new(Hash[value.map { |k, v| [k, build_ostruct_recursively(v)] }])
    when Array
      value.map { |v| build_ostruct_recursively(v) }
    else
      value
    end
  end

  # rubocop:disable Style/MethodName
  def with_A_variant(options = {})
    variant_options =
      { EducationNavigation: 'A' }
      .merge(options)

    with_variant variant_options do
      yield
    end
  end

  def with_B_variant(options = {})
    variant_options =
      { EducationNavigation: 'B' }
      .merge(options)

    with_variant variant_options do
      yield
    end
  end
  # rubocop:enable Style/MethodName
end
