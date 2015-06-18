require 'ostruct'

class Subtopic

  def self.find(base_path, pagination_options = {})
    api_response = Collections.services(:content_store).content_item!(base_path)
    new(api_response.to_hash, pagination_options)
  end

  def initialize(content_item_data, pagination_options = {})
    @content_item_data = content_item_data
    @pagination_options = pagination_options
  end

  [
    :base_path,
    :title,
    :description,
  ].each do |field|
    define_method field do
      @content_item_data[field.to_s]
    end
  end

  def beta?
    !! @content_item_data["details"]["beta"]
  end

  def parent
    if @content_item_data.has_key?("links") &&
        @content_item_data["links"].has_key?("parent") &&
        @content_item_data["links"]["parent"].any?
      OpenStruct.new(@content_item_data["links"]["parent"].first)
    else
      nil
    end
  end

  def combined_title
    if parent
      "#{parent.title}: #{title}"
    else
      title
    end
  end

  def groups
    Groups.new(base_path[1..-1], @content_item_data["details"]["groups"])
  end

private

  def self.filtered_api_options(options)
    options.slice(:start, :count).reject {|_,v| v.blank? }
  end
end
