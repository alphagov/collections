class TasklistContent
  def self.learn_to_drive_config
    @learn_to_drive_config ||= JSON.parse(
      File.read(
        Rails.root.join("config", "tasklists", "learn-to-drive-a-car.json")
        )
      ).deep_symbolize_keys
  end
end
