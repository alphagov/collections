class StepNavController < ApplicationController
  def show
    step_nav = StepNav.find!(request.path)

    setup_content_item_and_navigation_helpers(step_nav)

    render :show, locals: {
      content_item: step_nav,
    }
  end
end
