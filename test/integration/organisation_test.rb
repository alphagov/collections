require 'integration_test_helper'

class OrganisationTest < ActionDispatch::IntegrationTest
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
        ordered_featured_documents: [
          {
            title: "Government calls on technology firms to help tackle the UK’s biggest challenges",
            href: "/government/news/government-calls-on-technology-firms-to-help-tackle-the-uks-biggest-challenges",
            image: {
              url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/feature/image/62609/Dowden.jpg",
              alt_text: "Cabinet Office Minister Oliver Dowden"
            },
            summary: "The government is launching competitions for tech firms to develop solutions to tackle the major social challenges of our modern age.",
            public_updated_at: "2018-05-10T00:00:01.000+01:00",
            document_type: "Press release"
          },
        ],
        ordered_ministers: [
          {
            name_prefix: "The Rt Hon",
            name: "Theresa May MP",
            role: "Prime Minister",
            href: "/government/people/theresa-may",
            role_href: "/government/ministers/prime-minister",
            image: {
              url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/person/image/6/PM_portrait_960x640.jpg",
              alt_text: "Theresa May MP"
            }
          }
        ],
        social_media_links: [
          {
            service_type: "twitter",
            title: "Twitter - @10DowningStreet",
            href: "https://twitter.com/@10DowningStreet"
          },
          {
            service_type: "facebook",
            title: "Facebook",
            href: "https://www.facebook.com/10downingstreet"
          },
        ]
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
        ],
        ordered_featured_documents: [
          {
            title: "New head of the Serious Fraud Office announced",
            href: "/government/news/new-head-of-the-serious-fraud-office-announced",
            image: {
              url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/feature/image/63252/Jeremy_Wright_FOR_WEBSITE.jpg",
              alt_text: "Attorney General Jeremy Wright QC MP"
            },
            summary: "Lisa Osofsky appointed new Director of the Serious Fraud Office ",
            public_updated_at: "2018-06-04T11:30:03.000+01:00",
            document_type: "Press release"
          }
        ],
        ordered_ministers: [
          {
            name_prefix: "The Rt Hon",
            name: "Theresa May MP",
            role: "Prime Minister",
            href: "/government/people/theresa-may",
            role_href: "/government/ministers/prime-minister",
            image: {
              url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/person/image/6/PM_portrait_960x640.jpg",
              alt_text: "Theresa May MP"
            }
          },
          {
            name: "Stuart Andrew MP",
            role: "Parliamentary Under Secretary of State",
            href: "/government/people/stuart-andrew",
            role_href: "/government/ministers/parliamentary-under-secretary-of-state--94"
          }
        ],
        social_media_links: [
          {
            service_type: "twitter",
            title: "Twitter - @attorneygeneral",
            href: "https://twitter.com/@attorneygeneral"
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
        ],
        ordered_featured_documents: [
          {
            title: "Charity annual return 2018",
            href: "/government/news/charity-annual-return-2018",
            image: {
              url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/feature/image/63313/AR18_prepare_v1.1.png",
              alt_text: "Annual return service 2018"
            },
            summary: "How you can prepare for the 2018 annual return service, which will be available this summer. ",
            public_updated_at: "2018-06-06T10:56:00.000+01:00",
            document_type: "News story"
          }
        ],
        social_media_links: [
          {
            service_type: "twitter",
            title: "Twitter",
            href: "https://twitter.com/chtycommission"
          },
          {
            service_type: "youtube",
            title: "YouTube",
            href: "http://www.youtube.com/TheCharityCommission"
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
        ],
        ordered_featured_documents: [
          {
            title: "Welsh Secretary hails outstanding individuals in the Queen's Birthday Honours list",
            href: "/government/news/welsh-secretary-hails-outstanding-individuals-in-the-queens-birthday-honours-list",
            image: {
              url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/feature/image/63372/GOV.UK_honours_web.jpg",
              alt_text: "Queen's Birthday Honours"
            },
            summary: "Alun Cairns: \"I'm proud to see people from all walks of Welsh life honoured today\".",
            public_updated_at: "2018-06-08T23:23:11.000+01:00",
            document_type: "Press release"
          },
        ],
        social_media_links: [
          {
            service_type: "twitter",
            title: "Twitter",
            href: "https://twitter.com/UKGovWales"
          },
          {
            service_type: "twitter",
            title: "Trydar",
            href: "https://twitter.com/LlywDUCymru"
          }
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

    @content_item_blank = {
      title: "An empty content item to test everything checks before trying to render things",
      base_path: "/government/organisations/an-empty-thing",
      details: {
        body: "",
        brand: "",
        logo: {
        },
        organisation_govuk_status: {
          status: "",
        },
      },
      links: {
      }
    }

    content_store_has_item("/government/organisations/prime-ministers-office-10-downing-street", @content_item_no10)
    content_store_has_item("/government/organisations/attorney-generals-office", @content_item_attorney_general)
    content_store_has_item("/government/organisations/charity-commission", @content_item_charity_commission)
    content_store_has_item("/government/organisations/office-of-the-secretary-of-state-for-wales", @content_item_wales_office)
    content_store_has_item("/government/organisations/an-empty-thing", @content_item_blank)
  end

  it "doesn't fail if the content item is missing any data" do
    visit "/government/organisations/an-empty-thing"
    assert page.has_css?(".content")
  end

  it "sets the page title" do
    visit "/government/organisations/prime-ministers-office-10-downing-street"
    assert page.has_title?("Prime Minister's Office, 10 Downing Street - GOV.UK")

    visit "/government/organisations/attorney-generals-office"
    assert page.has_title?("Attorney General's Office - GOV.UK")

    visit "/government/organisations/charity-commission"
    assert page.has_title?("Charity Commission - GOV.UK")
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

  it "shows a large news item only on news organisations" do
    visit "/government/organisations/attorney-generals-office"
    assert page.has_css?(".gem-c-image-card.gem-c-image-card--large")

    visit "/government/organisations/charity-commission"
    refute page.has_css?(".gem-c-image-card.gem-c-image-card--large")
  end

  it "shows the ministers for an organisation" do
    visit "/government/organisations/attorney-generals-office"
    assert page.has_css?(".gem-c-heading", text: "Our ministers")
    assert page.has_css?('.gem-c-image-card .gem-c-image-card__title-link', text: 'Theresa May MP')
    assert page.has_css?('.gem-c-image-card .gem-c-image-card__title-link', text: 'Stuart Andrew MP')
  end

  it 'does not show the ministers section for no.10' do
    visit "/government/organisations/prime-ministers-office-10-downing-street"
    refute page.has_css?('.gem-c-heading', text: 'Our ministers')
    refute page.has_css?('.gem-c-image-card .gem-c-image-card__title-link', text: 'Theresa May MP')
  end

  it 'does not display ministers for organisations without minister data' do
    visit "/government/organisations/charity-commission"
    refute page.has_css?('.gem-c-heading', text: 'Our ministers')
  end
end
