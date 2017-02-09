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

  def with_new_navigation_enabled(&block)
    ClimateControl.modify(ENABLE_NEW_NAVIGATION: 'yes', &block)
  end
end
