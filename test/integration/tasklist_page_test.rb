require 'integration_test_helper'

class TasklistPageTest < ActionDispatch::IntegrationTest
  it "renders the learn to drive page" do
    visit "/learn-to-drive-a-car"

    assert page.has_css?(shared_component_selector('breadcrumbs'))

    within_static_component 'breadcrumbs' do |breadcrumb_arg|
      assert_equal [
        { "title" => "Home", "url" => "/" },
        { "title" => "Driving and transport", "url" => "/browse/driving" },
        { "title" => "Learning to drive", "url" => "/browse/driving/learning-to-drive" }
      ], breadcrumb_arg[:breadcrumbs]
    end

    assert page.has_css?(shared_component_selector('title'))

    within_static_component 'title' do |component_args|
      assert_equal "Learn to drive a car: step by step", component_args[:title]
    end

    assert page.has_css?(shared_component_selector('lead_paragraph'))

    within_static_component 'lead_paragraph' do |paragraph_args|
      assert_equal "Check what you need to do to learn to drive.", paragraph_args[:text]
    end

    assert page.has_css?(shared_component_selector('task_list'))

    within_static_component('task_list') do |tasklist_args|
      assert_equal 6, tasklist_args[:steps].count

      assert_equal [], tasklist_step_keys(tasklist_args) - %w(title panel panel_descriptions panel_links)

      assert_equal [], tasklist_panel_links_keys(tasklist_args) - %w(href text), []
    end
  end

  def tasklist_step_keys(tasklist_args)
    tasklist_args[:steps].flatten.flat_map(&:keys).uniq
  end

  def tasklist_panel_links_keys(tasklist_args)
    tasklist_args[:steps].flatten.flat_map { |step| step["panel_links"] }.flat_map(&:keys).uniq
  end
end
