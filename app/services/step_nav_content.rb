class StepNavContent
  def self.find_file(filename)
    JSON.parse(
      File.read(
        Rails.root.join("config", "step_nav", "#{filename}.json")
      )
    ).deep_symbolize_keys
  end
end
