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
      example_list.map { |example| ExampleLink.new(example) }
    end
  end

  def see_more_link
    if more_documents?
      {
        path: subsector_link,
        text: I18n.t("services_and_information.see_more_link"),
      }
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
