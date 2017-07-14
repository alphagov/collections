class ServicesAndInformationGroup
  attr_reader :group

  def initialize(group)
    @group = group
  end

  def title
    group.dig("value", "title")
  end

  def examples
    @examples ||= begin
      example_list = group.dig("value", "example_info", "examples") || []

      if more_documents?
        example_list << {
          'link' => subsector_link,
          'title' => 'See more',
          'class' => 'other'
        }
      end

      example_list.map { |example| ExampleLink.new(example) }
    end
  end

private

  def document_count
    group.dig("value", "example_info", "total")
  end

  def subsector_link
    group.dig("value", "link")
  end

  # Check if there are more documents than are being shown
  def more_documents?
    document_count > group.dig("value", "example_info", "examples").count
  end
end
