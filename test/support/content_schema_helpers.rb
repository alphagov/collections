module ContentSchemaHelpers
  def content_schema_examples_for(format)
    examples = GovukContentSchemaTestHelpers::Examples.new.get_all_for_format(format)
    examples.map { |json_example| JSON.parse(json_example) }
  end

  def content_schema_example(format, example_name)
    json_example = GovukContentSchemaTestHelpers::Examples.new.get(format, example_name)
    JSON.parse(json_example)
  end
end
