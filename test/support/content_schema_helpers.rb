module ContentSchemaHelpers
  def content_schema_examples_for(schema_name)
    # Shuffle the examples to ensure tests don't become order dependent
    GovukSchemas::Example.find_all(schema_name).shuffle
  end

  def content_schema_example(schema_name, example_name)
    GovukSchemas::Example.find(schema_name, example_name: example_name)
  end
end
