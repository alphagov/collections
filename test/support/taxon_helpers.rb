module TaxonHelpers
  # This taxon has grandchildren
  def funding_and_finance_for_students_taxon(params = {})
    fetch_and_validate_taxon(:funding_and_finance_for_students, params)
  end

  # This taxon does not have grandchildren
  def student_finance_taxon(params = {})
    fetch_and_validate_taxon(:student_finance, params)
  end

  # This taxon does not have any child taxons
  def running_an_education_institution_taxon(params = {})
    fetch_and_validate_taxon(:running_education_institution, params)
  end

  def student_sponsorship_taxon(params = {})
    fetch_and_validate_taxon(:student_sponsorship, params)
  end

  def student_loans_taxon(params = {})
    fetch_and_validate_taxon(:student_loans, params)
  end

  def world_usa_taxon(params = {})
    fetch_and_validate_taxon(:world_usa, params)
  end

  def world_usa_news_events_taxon(params = {})
    fetch_and_validate_taxon(:world_usa_news_events, params)
  end

  # This taxon has an associated_taxon
  def travelling_to_the_usa_taxon(params = {})
    fetch_and_validate_taxon(:travelling_to_the_usa, params)
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
