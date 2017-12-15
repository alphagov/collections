class TasklistController < ApplicationController
  def show
    content_item = ContentItem.find!("/learn-to-drive-a-car")

    render :show, locals: {
      content_item: content_item,
      tasklist: TasklistContent.learn_to_drive_config
    }
  end

  def show_end_a_civil_partnership
    render :show, locals: { tasklist: TasklistContent.end_a_civil_partnership_config }
  end
end
