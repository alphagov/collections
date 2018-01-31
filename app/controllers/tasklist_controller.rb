class TasklistController < ApplicationController
  def show
    content_item = ContentItem.find!(base_path)

    render :show, locals: {
      content_item: content_item,
      tasklist: TasklistContent.find_file(slug)
    }
  end

private

  def base_path
    request.path
  end

  def slug
    base_path[1..-1]
  end
end
