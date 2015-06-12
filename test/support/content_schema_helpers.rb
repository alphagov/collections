module ContentSchemaHelpers
  def content_schema_examples_for(format)
    examples = GovukContentSchemaTestHelpers::Examples.new.get_all_for_format(format)
    # Shuffle the examples to ensure tests don't become order dependent
    examples.map { |json_example| JSON.parse(json_example) }.shuffle
  end

  def content_schema_example(format, example_name)
    json_example = GovukContentSchemaTestHelpers::Examples.new.get(format, example_name)
    JSON.parse(json_example)
  end
end
