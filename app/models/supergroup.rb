class Supergroup
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def title
    name.humanize
  end

  def tagged_content
    rasie NotImplementedError.new
  end
end
