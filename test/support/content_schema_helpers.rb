module ContentSchemaHelpers
  def content_schema_examples_for(format)
    examples = GovukContentSchemaTestHelpers::Examples.new.get_all_for_format(format)
    examples.map { |json_example| JSON.parse(json_example) }
  end
end
