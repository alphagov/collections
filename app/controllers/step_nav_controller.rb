class StepNavController < ApplicationController
  def show
    step_by_step = StepNav.find!(request.path)
    setup_content_item_and_navigation_helpers(step_by_step)
    render :show, locals: { step_by_step: }
  end
end
