module TaxonHelpers
  # This taxon has grandchildren
  def funding_and_finance_for_students_taxon(params = {})
    fetch_and_validate_taxon(:funding_and_finance_for_students, params)
  end

  # This taxon does not have grandchildren
  def student_finance_taxon(params = {})
    fetch_and_validate_taxon(:student_finance, params)
  end

  def student_sponsorship_taxon(params = {})
    fetch_and_validate_taxon(:student_sponsorship, params)
  end

  def student_loans_taxon(params = {})
    fetch_and_validate_taxon(:student_loans, params)
  end

private

  def fetch_and_validate_taxon(basename, params = {})
    json = File.read(
      Rails.root.join('test', 'fixtures', 'content_store', "#{basename}.json")
    )
    content_item = JSON.parse(json)

    GovukSchemas::RandomExample
      .for_schema(frontend_schema: 'taxon')
      .merge_and_validate(content_item.merge(params))
  end
end
