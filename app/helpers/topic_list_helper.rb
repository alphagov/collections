module TopicListHelper
  def topic_list_item_tracking_attributes(tracking_attributes, title, path, index)
    tracking_attributes.deep_dup.tap do |t|
      t[:track_label] = path
      t[:track_options][:dimension29] = title
      t[:track_action] = "#{t[:track_action]}#{index + 1}"
    end
  end

  def topic_list_tracking_attributes(list_count, list_index, category)
    {
      track_category: category,
      track_action: list_index ? "#{list_index + 1}." : "",
      track_options: {
        dimension28: list_count.to_s,
      },
    }
  end

  def topic_list_params(list, tracking_attributes: nil, list_index: nil, category: nil)
    tracking_attributes ||= topic_list_tracking_attributes(list.count, list_index, category)

    {
      items: topic_list_items(list, tracking_attributes),
    }
  end

  def is_root_topic(topic)
    topic.base_path == '/topic'
  end

  def tracking_category(topic)
    is_root_topic(topic) ? "navTopicLinkClicked" : 'navSubtopicLinkClicked'
  end

  def eCommerce_subtopic_category(list, subtopic_title)
    return subtopic_title if list.title == "A to Z"
    list.title
  end

  def eCommerce_topic_category(topic)
     is_root_topic(topic) ? "topic index" : topic.title.downcase.to_s
  end

private

  def data_attributes(tracking_attributes, list_item, list_index)
    {
      ecommerce_row: list_index ? "#{list_index + 1}" : "",
      ecommerce_path: list_item.base_path,
    }.merge(
      topic_list_item_tracking_attributes(tracking_attributes, list_item.title, list_item.base_path, list_index),
    )
  end

  def topic_list_items(list, tracking_attributes)
    list.each_with_index.map do |list_item, list_item_index|
      {
        text: list_item.title,
        path: list_item.base_path,
        data_attributes: data_attributes(tracking_attributes, list_item, list_item_index),
      }
    end
  end
end
