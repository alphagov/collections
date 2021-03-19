require "integration_test_helper"

feature "Courts pages" do
  include CourtPagesHelper

  scenario "renders a courts page correctly" do
    when_i_visit_a_courts_page
    i_see_the_courts_breadcrumb
    and_the_breadcrumbs_collapse_on_mobile
    the_courts_title
    and_featured_links
    and_the_what_we_do_section
    and_contacts
    and_there_is_schema_org_information
    but_no_documents
    or_foi_section
    or_corporate_information
  end

  scenario "renders an HMCTS tribunal page correctly" do
    when_i_visit_an_hmcts_tribunal_page
    i_see_the_courts_breadcrumb
    and_the_breadcrumbs_collapse_on_mobile
    the_courts_title
    and_featured_links
    and_the_what_we_do_section
    and_contacts
    and_there_is_schema_org_information
    but_no_documents
    or_foi_section
    or_corporate_information
  end
end
