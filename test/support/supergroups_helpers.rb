module SupergroupHelpers
  def tagged_content(document_types)
    content_list = []
    document_types.each do |document_type|
      content_list.push(*section_tagged_content_list(document_type))
    end
    content_list
  end

  def expected_results(document_types)
    results = []
    document_types.each do |document_type|
      results.push(*expected_result(document_type))
    end
    results
  end

  def expected_result(document_type)
    result = {
      link: {
        text: 'Tagged Content Title',
        path: '/government/tagged/content'
      },
      metadata: {
        public_updated_at: '2018-02-28T08:01:00.000+00:00',
        organisations: 'Tagged Content Organisation',
        document_type: document_type.humanize,
      }
    }

    if consultation?(document_type)
      result[:metadata][:closing_date] = 'Date closed 10 July 2017'
    end

    [result]
  end

private

  def consultation?(document_type)
    document_type == 'open_consultation' ||
      document_type == 'consultation_outcome' ||
      document_type == 'closed_consultation'
  end
end
