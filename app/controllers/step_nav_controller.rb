class StepNavController < ApplicationController
  def show
    step_nav = StepNav.find!(request.path)

    setup_content_item_and_navigation_helpers(step_nav)

    step_nav_content = step_nav.details["step_by_step_nav"].deep_symbolize_keys

    render :show, locals: {
      content_item: step_nav,
      navigation_helpers: @navigation_helpers,
      step_nav: step_nav_content
    }
  end
end
