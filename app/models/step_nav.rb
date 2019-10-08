class StepNav
  attr_reader :content_item

  delegate(
    :content_id,
    :base_path,
    :title,
    :description,
    :details,
    :to_hash,
    to: :content_item,
  )

  def initialize(content_item)
    @content_item = content_item
  end

  def introduction
    details["step_by_step_nav"]["introduction"].html_safe
  end

  def payload_for_component
    details["step_by_step_nav"].deep_symbolize_keys.merge(remember_last_step: true, tracking_id: content_id)
  end

  def self.find!(base_path)
    content_item = ContentItem.find!(base_path)
    new(content_item)
  end
end
