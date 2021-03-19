require "integration_test_helper"

class TaxonBrowsingTest < ActionDispatch::IntegrationTest
  include TaxonBrowsingHelper

  it "renders a taxon page for a live taxon" do
    given_there_is_a_taxon_with_children
    and_the_taxon_is_live
    and_the_taxon_has_tagged_content
    when_i_visit_that_taxon
    then_i_can_see_the_title_section
    and_i_can_see_the_email_signup_link
    and_i_can_see_the_services_section
    and_i_can_see_the_guidance_and_regulation_section
    and_i_can_see_the_news_and_communications_section
    and_i_can_see_the_policy_papers_and_consulations_section
    and_i_can_see_the_transparency_and_foi_releases_section
    and_i_can_see_the_research_and_statistics_section
    and_i_can_see_the_organisations_section
    then_the_page_is_noindexed
  end

  it "renders a promoted item when there is only 1 tagged news item" do
    given_there_is_a_taxon_with_children
    and_the_taxon_is_live
    and_the_taxon_has_short_tagged_content
    when_i_visit_that_taxon
    then_i_can_see_the_short_news_and_communications_section
  end

  it "renders a taxon page for a draft taxon" do
    given_there_is_a_taxon_with_children
    and_the_taxon_is_not_live
    and_the_taxon_has_tagged_content
    when_i_visit_that_taxon
    then_the_page_is_noindexed
    and_i_cannot_see_an_email_signup_link
  end

  it "does not show anything but a taxon" do
    given_there_is_a_thing_that_is_not_a_taxon
    when_i_visit_that_thing
    then_there_should_be_an_error
  end

  it "renders an in-page nav" do
    given_there_is_a_taxon_with_children
    and_the_taxon_is_live
    and_the_taxon_has_tagged_content
    when_i_visit_that_taxon
    and_i_can_see_the_in_page_nav
  end

  it "has tracking on all links" do
    given_there_is_a_taxon_with_children
    and_the_taxon_is_live
    and_the_taxon_has_tagged_content
    when_i_visit_that_taxon
    then_all_links_have_tracking_data
  end
end
