module SupergroupHelpers
  def tagged_content(document_types)
    content_list = []
    document_types.each do |document_type|
      content_list.push(*section_tagged_content_list(document_type))
    end
    content_list
  end
end
