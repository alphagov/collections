require 'integration_test_helper'

class OrganisationHeaderTest < ActionDispatch::IntegrationTest
  before do
    @content_item_no10 = {
        title: "Prime Minister's Office, 10 Downing Street",
        base_path: "/government/organisations/prime-ministers-office-10-downing-street",
        details: {
            body: "10 Downing Street is the official residence and the office of the British Prime Minister.",
            brand: "cabinet-office",
            logo: {
                formatted_title: "Prime Minister&#39;s Office, 10 Downing Street",
                crest: "eo"
            },
            organisation_govuk_status: {
                status: "live",
            },
            organisation_type: "executive_office",
            organisation_featuring_priority: "news",
        },
        links: {
          available_translations: []
        }
    }

    @content_item_attorney_general = {
        title: "Attorney General's Office",
        base_path: "/government/organisations/attorney-generals-office",
        details: {
            body: "The Attorney General's Office (AGO) provides legal advice and support to the Attorney General and the Solicitor General (the Law Officers) who give legal advice to government. The AGO helps the Law Officers perform other duties in the public interest, such as looking at sentences which may be too low.\r\n\r\n",
            brand: "attorney-generals-office",
            logo: {
                formatted_title: "Attorney <br/>General&#39;s <br/>Office",
                crest: "single-identity"
            },
            organisation_govuk_status: {
                status: "live",
            },
            organisation_type: "ministerial_department",
            organisation_featuring_priority: "news",
            ordered_featured_links: [
              {
                title: "Attorney General's guidance to the legal profession",
                href: "https://www.gov.uk/browse/justice/courts-sentencing-tribunals/attorney-general-guidance-to-the-legal-profession"
              }
            ]
        },
        links: {
          available_translations: []
        }
    }

    @content_item_charity_commission = {
        title: "The Charity Commission",
        base_path: "/government/organisations/charity-commission",
        details: {
            body: "We register and regulate charities in England and Wales, to ensure that the public can support charities with confidence.\r\n",
            brand: "department-for-business-innovation-skills",
            logo: {
                formatted_title: "Charity Commission",
                image: {
                  url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/organisation/logo/98/Home_page.jpg",
                  alt_text: "The Charity Commission"
                }
            },
            organisation_govuk_status: {
                status: "live",
            },
            organisation_type: "non_ministerial_department",
            organisation_featuring_priority: "service",
            ordered_featured_links: [
              {
                title: "Find a charity",
                href: "http://apps.charitycommission.gov.uk/showcharity/registerofcharities/RegisterHomePage.aspx"
              },
              {
                title: "Online services and contact forms",
                href: "https://www.gov.uk/government/organisations/charity-commission/about/about-our-services"
              },
            ]
        },
        links: {
          available_translations: []
        }
    }

    @content_item_wales_office = {
        title: "The Charity Commission",
        base_path: "/government/organisations/charity-commission",
        details: {
            body: "We register and regulate charities in England and Wales, to ensure that the public can support charities with confidence.\r\n",
            brand: "department-for-business-innovation-skills",
            logo: {
                formatted_title: "Charity Commission",
                image: {
                  url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/organisation/logo/98/Home_page.jpg",
                  alt_text: "The Charity Commission"
                }
            },
            organisation_govuk_status: {
                status: "live",
            },
            organisation_type: "non_ministerial_department",
            ordered_featured_links: [
              {
                title: "Find a charity",
                href: "http://apps.charitycommission.gov.uk/showcharity/registerofcharities/RegisterHomePage.aspx"
              },
              {
                title: "Online services and contact forms",
                href: "https://www.gov.uk/government/organisations/charity-commission/about/about-our-services"
              },
            ]
        },
        links: {
          available_translations: [
            {
                "base_path": "/government/organisations/office-of-the-secretary-of-state-for-wales.cy",
                "locale": "cy",
            },
            {
                "base_path": "/government/organisations/office-of-the-secretary-of-state-for-wales",
                "locale": "en",
            }
        ]
        }
    }

    content_store_has_item("/government/organisations/prime-ministers-office-10-downing-street", @content_item_no10)
    content_store_has_item("/government/organisations/attorney-generals-office", @content_item_attorney_general)
    content_store_has_item("/government/organisations/charity-commission", @content_item_charity_commission)
    content_store_has_item("/government/organisations/office-of-the-secretary-of-state-for-wales", @content_item_wales_office)
  end

  it "shows the no10 banner element only on no10's page" do
    visit "/government/organisations/prime-ministers-office-10-downing-street"
    assert page.has_css?(".no10-banner", text: "Prime Minister's Office, 10 Downing Street")

    visit "/government/organisations/attorney-generals-office"
    refute page.has_css?(".no10-banner")

    visit "/government/organisations/charity-commission"
    refute page.has_css?(".no10-banner")
  end

  it "renders the logo and logo brand correctly" do
    visit "/government/organisations/prime-ministers-office-10-downing-street"
    refute page.has_css?(".gem-c-organisation-logo")

    visit "/government/organisations/attorney-generals-office"
    assert page.has_css?(".gem-c-organisation-logo.brand--attorney-generals-office .gem-c-organisation-logo__name", text: "Attorney General's Office")

    visit "/government/organisations/charity-commission"
    assert page.has_css?(".gem-c-organisation-logo.brand--department-for-business-innovation-skills img[alt='The Charity Commission']")
  end

  it "shows featured links correctly if present" do
    visit "/government/organisations/prime-ministers-office-10-downing-street"
    refute page.has_css?(".app-c-topic-list")

    visit "/government/organisations/attorney-generals-office"
    assert page.has_css?(".app-c-topic-list.app-c-topic-list--small")

    visit "/government/organisations/charity-commission"
    assert page.has_css?(".app-c-topic-list")
    refute page.has_css?(".app-c-topic-list.app-c-topic-list--small")
  end

  it "shows the translation nav if required" do
    visit "/government/organisations/prime-ministers-office-10-downing-street"
    refute page.has_css?(".gem-c-translation-nav")

    visit "/government/organisations/attorney-generals-office"
    refute page.has_css?(".gem-c-translation-nav")

    visit "/government/organisations/office-of-the-secretary-of-state-for-wales"
    assert page.has_css?(".gem-c-translation-nav")
  end
end
