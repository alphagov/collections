class TasklistContent
  def self.learn_to_drive_config
    @learn_to_drive_config ||= find_file("learn-to-drive-a-car")
  end

  def self.end_a_civil_partnership_config
    @end_a_civil_partnership_config ||= find_file("end-a-civil-partnership")
  end

  def self.find_file(filename)
    JSON.parse(
      File.read(
        Rails.root.join("config", "tasklists", "#{filename}.json")
      )
    ).deep_symbolize_keys
  end
end
