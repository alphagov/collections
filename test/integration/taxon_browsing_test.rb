require 'integration_test_helper'

class TaxonBrowsingTest < ActionDispatch::IntegrationTest
  include RummagerHelpers

  it 'renders a taxon page for a live taxon' do
    given_there_is_a_taxon_with_children
    and_the_taxon_is_live
    and_the_taxon_has_tagged_content
    when_i_visit_that_taxon
    then_i_can_see_the_title_section
    and_i_can_see_the_email_signup_link
    and_i_can_see_the_services_section
    and_i_can_see_the_guidance_and_regulation_section
    and_i_can_see_the_news_and_communications_section
    and_i_can_see_the_sub_topics_grid
  end

  it 'renders a taxon page for a draft taxon' do
    given_there_is_a_taxon_with_children
    and_the_taxon_is_not_live
    and_the_taxon_has_tagged_content
    when_i_visit_that_taxon
    then_page_has_meta_robots
    and_i_cannot_see_an_email_signup_link
  end

private

  def given_there_is_a_taxon_with_children
    child_one_base_path = "#{base_path}/child-1"
    child_two_base_path = "#{base_path}/child-2"

    child_one = {
      "base_path" => child_one_base_path,
      "content_id" => "36dd87da-4973-5490-ab00-72025b1da601",
      "title" => "Child One",
      "phase" => "live",
      "locale" => "en",
    }

    child_two = {
      "base_path" => child_two_base_path,
      "content_id" => "36dd87da-4973-5490-ab00-72025b1da602",
      "title" => "Child Two",
      "phase" => "live",
      "locale" => "en",
    }

    content_store_has_item(child_one_base_path, child_one)
    content_store_has_item(child_two_base_path, child_two)

    @content_item = content_item_without_children(base_path, content_id)

    @content_item["links"]["child_taxons"] = [child_one, child_two]
  end

  def and_the_taxon_is_live
    @content_item["phase"] = "live"
    content_store_has_item(base_path, @content_item)
  end

  def and_the_taxon_is_not_live
    @content_item["phase"] = "beta"
    content_store_has_item(base_path, @content_item)
  end

  def and_the_taxon_has_tagged_content
    # We still need to stub tagged content because it is used by the sub-topic grid
    stub_content_for_taxon(content_id, tagged_content)
    stub_most_popular_content_for_taxon(content_id, tagged_content, filter_content_purpose_supergroup: 'guidance_and_regulation')
    stub_most_popular_content_for_taxon(content_id, tagged_content, filter_content_purpose_supergroup: 'services')
    stub_most_recent_content_for_taxon(content_id, tagged_content, filter_content_purpose_supergroup: 'news_and_communications')
  end

  def when_i_visit_that_taxon
    visit base_path
  end

  def then_i_can_see_the_title_section
    assert page.has_selector?('title', text: "Taxon title", visible: false)
    assert_not_nil shared_component_selector('breadcrumbs')
  end

  def and_i_can_see_the_email_signup_link
    assert page.has_link?(
      'Sign up for updates to this topic page',
      href: "/email-signup/?topic=#{current_path}"
    )
  end

  def and_i_cannot_see_an_email_signup_link
    refute page.has_link?(
      'Sign up for updates to this topic page',
      href: "/email-signup/?topic=#{current_path}"
    )
  end

  def and_i_can_see_the_guidance_and_regulation_section
    assert page.has_content?('Guidance and regulation')

    tagged_content.each do |item|
      assert page.has_link?(item["title"], href: item["link"])
    end

    expected_link = {
      text: "See all guidance and regulation",
      url: "/search/advanced?" + finder_query_string("guidance_and_regulation")
    }

    assert page.has_link?(expected_link[:text], href: expected_link[:url])
  end

  def and_i_can_see_the_services_section
    assert page.has_content?('Services')

    tagged_content.each do |item|
      assert page.has_link?(item["title"], href: item["link"])
    end

    expected_link = {
      text: "See all services",
      url: "/search/advanced?" + finder_query_string('services')
    }

    assert page.has_link?(expected_link[:text], href: expected_link[:url])
  end

  def and_i_can_see_the_news_and_communications_section
    assert page.has_content?("News and communications")

    tagged_content.each do |item|
      assert page.has_link?(item["title"], href: item["link"])
    end

    expected_link = {
      text: "See all news and communications",
      url: "/search/advanced?" + finder_query_string("news_and_communications")
    }

    assert page.has_link?(expected_link[:text], href: expected_link[:url])
  end

  def and_i_can_see_the_sub_topics_grid
    assert page.has_selector?('nav.taxon-page__grid')

    child_taxons = @content_item["links"]["child_taxons"]

    child_taxons.each do |child_taxon|
      assert page.has_link?(child_taxon['title'], href: child_taxon['base_path'])
    end
  end

  def then_page_has_meta_robots
    content = page.find('meta[name="robots"]', visible: false)['content']

    assert_equal(
      "noindex, nofollow",
      content,
      "The content of the robots meta tag should be 'noindex, nofollow'"
    )
  end

  def base_path
    "/foo"
  end

  def content_id
    "36dd87da-4973-5490-ab00-72025b1da600"
  end

  def content_item_without_children(base_path, content_id)
    GovukSchemas::RandomExample.for_schema(frontend_schema: "taxon") do |item|
      item.merge(
        "base_path" => base_path,
        "content_id" => content_id,
        "title" => "Taxon title",
        "phase" => "live",
        "links" => {},
      )
    end
  end

  def tagged_content
    generate_search_results(5)
  end

  def finder_query_string(supergroup)
    {
      taxons: @content_item['base_path'],
      content_purpose_supergroup: supergroup
    }.to_query
  end
end
