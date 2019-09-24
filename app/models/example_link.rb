require "active_model"

class ExampleLink
  include ActiveModel::Model

  attr_accessor(
    :title,
    :link,
    :class,
  )

  def base_path
    link
  end
end
