class ListSet
  include Enumerable
  delegate :each, to: :lists

  def initialize(linked_content, group_data, excluded_document_types = [])
    @linked_content = linked_content || []
    @group_data = group_data || []
    @excluded_document_types = excluded_document_types
  end

  def curated?
    @group_data.any?
  end

private

  def lists
    if @group_data.any?
      curated_list
    else
      a_to_z_list
    end
  end

  def a_to_z_list
    az_list = @linked_content
      .reject { |content| @excluded_document_types.include? content.document_type }
      .map { |content| LinkedContent.new(content.title, content.base_path) }
      .sort_by(&:title)

    [ListSet::List.new("A to Z", az_list)]
  end

  def curated_list
    curated_data = @group_data.map do |group|
      contents = group["contents"].map do |base_path|
        link = @linked_content.find { |content| content.base_path == base_path }
        link.nil? ? nil : LinkedContent.new(link.title, link.base_path)
      end

      ListSet::List.new(group["name"], contents.compact) if contents.any?
    end

    curated_data.compact
  end

  LinkedContent = Struct.new(
    :title,
    :base_path,
  )
end
