class StepNavContent
  def self.find_file(filename)
    JSON.parse(
      File.read(
        Rails.root.join("config", "step_nav", "#{filename}.json")
      )
    ).deep_symbolize_keys
  end

  def self.from_content_item(content_item)
    content_item.details["step_by_step_nav"].deep_symbolize_keys
  end

end
