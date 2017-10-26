class TasklistController < ApplicationController
  def show
    render :show, locals: { tasklist: TasklistContent.learn_to_drive_config }
  end
end
