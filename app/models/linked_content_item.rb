LinkedContentItem = Struct.new(:title, :base_path, :description) do
  def self.build(attributes)
    new(attributes["title"], attributes["base_path"], attributes["description"])
  end
end
