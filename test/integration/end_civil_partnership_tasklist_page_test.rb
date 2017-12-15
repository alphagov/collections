require 'integration_test_helper'

class EndCivilPartnershipTasklistPageTest < ActionDispatch::IntegrationTest
  before do
    path = "/end-a-civil-partnership"
    content_store_has_item(path, schema: 'generic')

    visit path
  end

  it "renders the breadcrumbs in the end a civil partnership page" do
    assert page.has_css?(shared_component_selector('breadcrumbs'))

    within_static_component 'breadcrumbs' do |breadcrumb_arg|
      assert_equal [
        { "title" => "Home", "url" => "/" },
        { "title" => "Births, deaths, marriages and care", "url" => "/browse/births-deaths-marriages" },
        { "title" => "Marriage, civil partnership and divorce", "url" => "/browse/births-deaths-marriages/marriage-divorce" }
      ], breadcrumb_arg[:breadcrumbs]
    end
  end

  it "renders the title in the end a civil partnership page" do
    assert page.has_css?(shared_component_selector('title'))

    within_static_component 'title' do |component_args|
      assert_equal "End a civil partnership: step by step", component_args[:title]
    end
  end

  it "renders the tasklist in the end a civil partnership page" do
    assert page.has_css?(tasklist_component)

    within(tasklist_component) do
      group_titles = [
        "Get support and advice",
        "Check you can end a civil partnership",
        "Make arrangements for your children, money and property",
        "File an application",
        "Send the court more details about ending your civil partnership",
        "Finalise your divorce"
      ]

      group_titles.each_with_index do |group_title, index|
        step = index + 1

        assert_match("Step #{step} #{group_title}", page.text)
      end
    end
  end

  def tasklist_component
    "[data-module='gemtasklist']"
  end
end
