class TasklistContent
  def self.find_file(filename)
    JSON.parse(
      File.read(
        Rails.root.join("config", "tasklists", "#{filename}.json")
      )
    ).deep_symbolize_keys
  end
end
