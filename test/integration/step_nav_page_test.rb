require 'integration_test_helper'

class StepNavPageTest < ActionDispatch::IntegrationTest
  before do
    path = '/learn-to-drive-a-car'
    content_store_has_item(path, schema: 'generic')

    visit path
  end

  it "renders the breadcrumbs in learn to drive page" do
    assert page.has_css?(shared_component_selector('breadcrumbs'))

    within_static_component 'breadcrumbs' do |breadcrumb_arg|
      assert_equal [
        { "title" => "Home", "url" => "/" },
        { "title" => "Driving and transport", "url" => "/browse/driving" },
        { "title" => "Learning to drive", "url" => "/browse/driving/learning-to-drive" }
      ], breadcrumb_arg[:breadcrumbs]
    end
  end

  it "renders the title in learn to drive page" do
    assert page.has_css?(shared_component_selector('title'))

    within_static_component 'title' do |component_args|
      assert_equal "Learn to drive a car: step by step", component_args[:title]
    end
  end

  it "renders the step navigation in learn to drive page" do
    assert page.has_selector?(".gem-c-step-nav")
    assert page.has_selector?(".gem-c-step-nav__title", text: "Check you're allowed to drive")
    assert page.has_selector?(".gem-c-step-nav__step", count: 7)
  end

  it "hides step content by default" do
    assert page.has_selector?(".gem-c-step-nav__panel", count: 7, visible: false)
  end
end
