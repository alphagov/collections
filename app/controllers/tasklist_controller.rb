class TasklistController < ApplicationController
  def show
    content_item = ContentItem.find!("/learn-to-drive-a-car")

    render :show, locals: {
      content_item: content_item,
      tasklist: TasklistContent.learn_to_drive_config
    }
  end

  def show_end_a_civil_partnership
    content_item = ContentItem.find!("/end-a-civil-partnership")

    render :show, locals: {
      content_item: content_item,
      tasklist: TasklistContent.end_a_civil_partnership_config
    }
  end

  def show_get_a_divorce
    content_item = ContentItem.find!("/get-a-divorce")

    render :show, locals: {
      content_item: content_item,
      tasklist: TasklistContent.get_a_divorce_config
    }
  end
end
