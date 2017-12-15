require 'integration_test_helper'

class TasklistPageTest < ActionDispatch::IntegrationTest

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

  it "renders the tasklist in learn to drive page" do
    assert page.has_css?(tasklist_component)

    within(tasklist_component) do
      group_titles = [
         "Check you're allowed to drive",
         "Get a provisional driving licence",
         "Driving lessons and practice",
         "Book and manage your theory test",
         "Book and manage your driving test",
         "When you pass"
      ]

      group_titles.each_with_index do |group_title, index|
        step = index + 1
        fourth_title = group_titles[5]

        if group_title == fourth_title
          assert_match(group_title, page.text)
        else
          assert_match("Step #{step} #{group_title}", page.text)
        end
      end
    end
  end

  def tasklist_component
    "[data-module='gemtasklist']"
  end
end
