class StepNavController < ApplicationController
  def show
    setup_content_item_and_navigation_helpers(step_nav)

    step_nav_content = StepNavContent.from_content_item(step_nav)

    render :show, locals: {
      content_item: step_nav,
      navigation_helpers: @navigation_helpers,
      step_nav: step_nav_content
    }
  end

private

  def base_path
    request.path
  end

  def slug
    base_path[1..-1]
  end

  def step_nav
    StepNav.find!(base_path)
  end
end
