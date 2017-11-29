class TasklistController < ApplicationController
  def show
    content_item = ContentItem.find!("/learn-to-drive-a-car")

    render :show, locals: {
      content_item: content_item,
      tasklist: TasklistContent.learn_to_drive_config
    }
  end
end
