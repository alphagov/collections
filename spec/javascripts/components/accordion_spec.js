describe('An accordion module', function () {
  'use strict'

  var $element
  var accordion
  var html =
    '<div class="app-c-accordion js-hidden" data-module="accordion">' +
      '<div class="app-c-accordion__section js-section" id="topic-section-one">' +
        '<div class="app-c-accordion__header js-toggle-panel">' +
          '<h2 class="app-c-accordion__title js-section-title">Topic Section One</h2>' +
          '<p class="app-c-accordion__description">Subsection description in here</p>' +
        '</div>' +
        '<div class="app-c-accordion__panel js-panel" id="section_panel_10_0">' +
          '<ul>' +
            '<li>' +
              '<a href="">list item in here</a>' +
            '</li>' +
          '</ul>' +
        '</div>' +
      '</div>' +
      '<div class="app-c-accordion__section js-section" id="topic-section-two">' +
        '<div class="app-c-accordion__header js-toggle-panel">' +
          '<h2 class="app-c-accordion__title js-section-title">Topic Section Two</h2>' +
          '<p class="app-c-accordion__description">Subsection description in here</p>' +
        '</div>' +
        '<div class="app-c-accordion__panel js-panel" id="section_panel_11_1">' +
          '<ul>' +
            '<li>' +
              '<a href="">list item in here</a>' +
            '</li>' +
          '</ul>' +
        '</div>' +
      '</div>' +
    '</div>'
  var expectedAccordionSectionCount = 2
  var expectedAccordionContentCount = 1

  beforeEach(function () {
    accordion = new GOVUK.Modules.CollectionsAccordion()
    $element = $(html)
    accordion.start($element)
  })

  afterEach(function () {
    $(document).off()
    location.hash = '#'
  })

  it('has a class of app-c-accordion--active to indicate the js has loaded', function () {
    expect($element).toHaveClass('app-c-accordion--active')
  })

  it('is not hidden', function () {
    expect($element).not.toHaveClass('js-hidden')
  })

  it('has an open/close all button', function () {
    var $openCloseAllButton = $element.find('.js-section-controls-button')

    expect($openCloseAllButton).toExist()
    expect($openCloseAllButton).toHaveText('Open all')
    // It has an aria-expanded false attribute as all subsections are closed
    expect($openCloseAllButton).toHaveAttr('aria-expanded', 'false')
    // It has an aria-controls attribute that includes all the subsection_content IDs
    expect($openCloseAllButton).toHaveAttr('aria-controls', 'section_panel_10_0 section_panel_11_1 ')
  })

  it('has no sections which have an open state', function () {
    var openSubsections = $element.find('.section-is-open').length
    expect(openSubsections).toEqual(0)
  })

  it('inserts a button into each section to show/hide content', function () {
    var $titleButton = $element.find('.app-c-accordion__header .app-c-accordion__button--title')

    expect($titleButton).toHaveClass('app-c-accordion__button--title')
    expect($titleButton).toHaveAttr('aria-expanded', 'false')
    expect($titleButton[0]).toHaveAttr('aria-controls', 'section_panel_10_0')
    expect($titleButton[1]).toHaveAttr('aria-controls', 'section_panel_11_1')
  })

  it('ensures all subsection content is hidden', function () {
    $element.find('.app-c-accordion__section').each(function (index, $subsection) {
      expect($subsection).not.toHaveClass('section-is-open')
    })
  })

  it('adds an open/close icon to each subsection', function () {
    var $subsectionHeader = $element.find('.app-c-accordion__header')
    expect($subsectionHeader).toContainElement('.app-c-accordion__icon')
  })

  describe('Clicking the "Expand all" button', function () {
    beforeEach(function () {
      GOVUK.analytics = {
        trackEvent: function () {
        }
      }
      spyOn(GOVUK.analytics, 'trackEvent')
      clickOpenCloseAll()
    })

    it('adds a .subsection-is-open class to each subsection to hide the icon', function () {
      expect($element.find('.section-is-open').length).toEqual(2)
    })

    it('adds an aria-expanded attribute to each section link', function () {
      expect($element.find('.js-section-title-button[aria-expanded="true"]').length).toEqual(2)
    })

    it('changes the Open/Close all button text to "Close all"', function () {
      expect($element.find('.js-section-controls-button')).toContainText('Close all')
    })

    it('triggers a google analytics custom event', function () {
      expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith('pageElementInteraction', 'accordionAllOpened', {
        label: 'Open All',
        dimension28: expectedAccordionSectionCount.toString()
      })
    })
  })

  describe('Clicking the "Close all" button', function () {
    it('triggers a google analytics custom event', function () {
      GOVUK.analytics = {
        trackEvent: function () {
        }
      }
      spyOn(GOVUK.analytics, 'trackEvent')

      clickOpenCloseAll()
      clickOpenCloseAll()

      expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith('pageElementInteraction', 'accordionAllClosed', {
        label: 'Close All',
        dimension28: expectedAccordionSectionCount.toString()
      })
    })
  })

  describe('Opening a section', function () {
    // When a section is open (testing: toggleSection, openSection)
    it('has a class of section-is-open', function () {
      var $subsectionLink = $element.find('.app-c-accordion__header .app-c-accordion__button--title')
      var $subsection = $element.find('.app-c-accordion__section')
      $subsectionLink.click()
      expect($subsection).toHaveClass('section-is-open')
    })

    // When a section is open (testing: toggleState, setExpandedState)
    it('has a an aria-expanded attribute and the value is true', function () {
      var $subsectionLink = $element.find('.app-c-accordion__header .app-c-accordion__button--title')
      $subsectionLink.click()
      expect($subsectionLink).toHaveAttr('aria-expanded', 'true')
    })

    it('triggers a google analytics custom event when clicking on the title', function () {
      GOVUK.analytics = {
        trackEvent: function () {
        }
      }
      spyOn(GOVUK.analytics, 'trackEvent')

      var $subsectionLink = $element.find('.app-c-accordion__header .app-c-accordion__button--title')
      $subsectionLink.click()

      expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith('pageElementInteraction', 'accordionOpened', {
        label: '1. Topic Section One',
        dimension28: expectedAccordionContentCount.toString()
      })
    })

    it('triggers a google analytics custom event when clicking on the icon', function () {
      GOVUK.analytics = {
        trackEvent: function () {
        }
      }
      spyOn(GOVUK.analytics, 'trackEvent')

      var $subsectionIcon = $element.find('.app-c-accordion__icon')
      $subsectionIcon.click()

      expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith('pageElementInteraction', 'accordionOpened', {
        label: '1. Topic Section One',
        dimension28: expectedAccordionContentCount.toString()
      })
    })

    it('triggers a google analytics custom event when clicking in space in the header', function () {
      GOVUK.analytics = {
        trackEvent: function () {
        }
      }
      spyOn(GOVUK.analytics, 'trackEvent')

      var $subsectionHeader = $element.find('.app-c-accordion__header')
      $subsectionHeader.click()

      expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith('pageElementInteraction', 'accordionOpened', {
        label: '1. Topic Section One',
        dimension28: expectedAccordionContentCount.toString()
      })
    })
  })

  describe('Closing a section', function () {
    // When a section is closed (testing: toggleSection, closeSection)
    it('removes the section-is-open class', function () {
      var $subsectionLink = $element.find('.app-c-accordion__header .app-c-accordion__button--title')
      var $subsection = $element.find('.app-c-accordion__section')
      $subsectionLink.click()
      expect($subsection).toHaveClass('section-is-open')
      $subsectionLink.click()
      expect($subsection).not.toHaveClass('section-is-open')
    })

    // When a section is closed (testing: toggleState, setExpandedState)
    it('has a an aria-expanded attribute and the value is false', function () {
      var $subsectionLink = $element.find('.app-c-accordion__header .app-c-accordion__button--title')
      $subsectionLink.click()
      expect($subsectionLink).toHaveAttr('aria-expanded', 'true')
      $subsectionLink.click()
      expect($subsectionLink).toHaveAttr('aria-expanded', 'false')
    })

    it('triggers a google analytics custom event when clicking on the title', function () {
      GOVUK.analytics = {
        trackEvent: function () {
        }
      }
      spyOn(GOVUK.analytics, 'trackEvent')

      var $subsectionLink = $element.find('.app-c-accordion__header .app-c-accordion__button--title')
      $subsectionLink.click()
      $subsectionLink.click()

      expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith('pageElementInteraction', 'accordionClosed', {
        label: '1. Topic Section One',
        dimension28: expectedAccordionContentCount.toString()
      })
    })

    it('triggers a google analytics custom event when clicking on the icon', function () {
      GOVUK.analytics = {
        trackEvent: function () {
        }
      }
      spyOn(GOVUK.analytics, 'trackEvent')

      var $subsectionIcon = $element.find('.app-c-accordion__icon')
      $subsectionIcon.click()
      $subsectionIcon.click()

      expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith('pageElementInteraction', 'accordionClosed', {
        label: '1. Topic Section One',
        dimension28: expectedAccordionContentCount.toString()
      })
    })

    it('triggers a google analytics custom event when clicking in space in the header', function () {
      GOVUK.analytics = {
        trackEvent: function () {
        }
      }
      spyOn(GOVUK.analytics, 'trackEvent')

      accordion.start($element)
      var $subsectionHeader = $element.find('.app-c-accordion__header')
      $subsectionHeader.click()
      $subsectionHeader.click()

      expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith('pageElementInteraction', 'accordionClosed', {
        label: '1. Topic Section One',
        dimension28: expectedAccordionContentCount.toString()
      })
    })
  })

  describe('When linking to a topic section', function () {
    beforeEach(function () {
      spyOn(GOVUK, 'getCurrentLocation').and.returnValue({
        hash: '#topic-section-one'
      })

      // Restart accordion after setting up mock location provider
      accordion.start($element)
    })

    it('opens the linked to topic section', function () {
      var $subsection = $element.find('#topic-section-one')
      expect($subsection).toHaveClass('section-is-open')
    })

    it('leaves other sections closed', function () {
      var $subsection = $element.find('#topic-section-two')
      expect($subsection).not.toHaveClass('section-is-open')
    })
  })

  function clickOpenCloseAll () {
    $element.find('.js-section-controls-button').click()
  }
})
