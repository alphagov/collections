class StepNavContent
  def self.from_content_item(content_item)
    content_item.details["step_by_step_nav"].deep_symbolize_keys
  end
end
