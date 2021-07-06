describe('Coronavirus landing page', function () {
  'use strict'

  var coronavirusLandingPage
  var html =
    '<div id="element" data-module="coronavirus-landing-page">' +
      '<div class="gem-c-accordion" data-module="gem-accordion">' +
        '<div class="gem-c-accordion__controls">' +
          '<button type="button" class="gem-c-accordion__open-all" aria-expanded="false">' +
            'Open all<span class="govuk-visually-hidden"> sections</span>' +
          '</button>' +
        '</div>' +
        '<div class="gem-c-accordion__section">' +
          '<div class="gem-c-accordion__section-header">' +
            '<h3 class="gem-c-accordion__section-heading">' +
              '<button type="button">How to protect yourself and others</button><span class="gem-c-accordion__icon" aria-hidden="true"></span>' +
            '</h3>' +
          '</div>' +
          '<div class="gem-c-accordion__section-content">accordion content</div>' +
        '</div>' +
      '</div>' +
    '</div>'
  var $element

  beforeEach(function () {
    coronavirusLandingPage = new GOVUK.Modules.CoronavirusLandingPage()
    $element = $(html)
    GOVUK.approveAllCookieTypes()
  })

  it('sets global_bar_seen to automatically hide if on /coronavirus', function () {
    GOVUK.cookie('global_bar_seen', JSON.stringify({ count: 0, version: 1 }))
    spyOn(coronavirusLandingPage, 'checkOnLandingPage').and.returnValue(true)
    coronavirusLandingPage.start($element)

    expect(parseCookie(GOVUK.cookie('global_bar_seen')).count).toBe(999)
  })

  it('only sets global_bar_seen if on /coronavirus', function () {
    GOVUK.cookie('global_bar_seen', JSON.stringify({ count: 0, version: 1 }))
    spyOn(coronavirusLandingPage, 'checkOnLandingPage').and.returnValue(false)
    coronavirusLandingPage.start($element)

    expect(parseCookie(GOVUK.cookie('global_bar_seen')).count).not.toBe(999)
    expect(parseCookie(GOVUK.cookie('global_bar_seen')).version).toBe(1)
  })

  describe('Clicking the "Open all" button', function () {
    beforeEach(function () {
      GOVUK.analytics = {
        trackEvent: function () {
        }
      }
      spyOn(GOVUK.analytics, 'trackEvent')

      // similate gem-c-accordion module
      $element.find('.gem-c-accordion__open-all').on('click', function (e) {
        var expanded = $(e.target).attr('aria-expanded') === 'true'
        $(e.target).attr('aria-expanded', expanded ? 'false' : 'true')
      })

      coronavirusLandingPage.start($element)
    })

    it('tracks expanding', function () {
      var $openCloseAllButton = $element.find('.gem-c-accordion__open-all')

      expect($openCloseAllButton).toExist()
      expect($openCloseAllButton.attr('aria-expanded')).toBe('false')
      $openCloseAllButton.trigger('click')

      expect($openCloseAllButton.attr('aria-expanded')).toBe('true')
      expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith(
        'pageElementInteraction', 'accordionOpened', { transport: 'beacon', label: 'Expand all' }
      )
    })

    it('tracks collapsing', function () {
      var $openCloseAllButton = $element.find('.gem-c-accordion__open-all')
      $openCloseAllButton.attr('aria-expanded', 'true')

      expect($openCloseAllButton).toExist()
      expect($openCloseAllButton).toHaveAttr('aria-expanded', 'true')
      $openCloseAllButton.trigger('click')

      expect($openCloseAllButton.attr('aria-expanded')).toBe('false')
      expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith(
        'pageElementInteraction', 'accordionClosed', { transport: 'beacon', label: 'Collapse all' }
      )
    })
  })

  describe('nation selector controls', function () {
    var nationPickerHtml

    beforeEach(function () {
      nationPickerHtml =
        '<div>' +
          '<p>Showing updates for <span class="js-current-nation">England</span></p>' +
          '<form method="get" target="" class="js-change-location">' +
            '<div class="gem-c-radio govuk-radios__item">' +
              '<input type="radio" name="nation" id="radio-0" value="england" class="govuk-radios__input" checked="">' +
              '<label for="radio-0" class="gem-c-label govuk-label govuk-radios__label">England</label>' +
            '</div>' +
            '<div class="gem-c-radio govuk-radios__item">' +
              '<input type="radio" name="nation" id="radio-1" value="northern_ireland" class="govuk-radios__input">' +
              '<label for="radio-1" class="gem-c-label govuk-label govuk-radios__label">Northern Ireland</label>' +
            '</div>' +
          '</form>' +
          '<div id="nation-england" class="js-covid-timeline">England</div>' +
          '<div id="nation-northern_ireland" class="js-covid-timeline">Northern Ireland</div>' +
        '</div>'
      coronavirusLandingPage = new GOVUK.Modules.CoronavirusLandingPage()
      $element = $(nationPickerHtml)
      $('body').append($element)
      coronavirusLandingPage.start($element)
    })

    afterEach(function () {
      $element.remove()
    })

    it('show and hide appropriate sections of the page when the radio buttons change', function () {
      var status = $element.find('.js-current-nation')
      var radio0 = $element.find('#radio-0')
      var radio1 = $element.find('#radio-1')
      var section0 = $element.find('#nation-england')
      var section1 = $element.find('#nation-northern_ireland')

      window.GOVUK.triggerEvent(radio0[0], 'change')

      expect(section0).toBeVisible()
      expect(section1).toBeHidden()
      expect(status.text()).toBe('england')

      window.GOVUK.triggerEvent(radio1[0], 'change')

      expect(section0).toBeHidden()
      expect(section1).toBeVisible()
      expect(status.text()).toBe('northern ireland')
    })
  })
})

function parseCookie (cookie) {
  var parsedCookie = JSON.parse(cookie)

  // Tests seem to run differently on CI, and require an extra parse
  if (typeof parsedCookie !== 'object') {
    parsedCookie = JSON.parse(parsedCookie)
  }

  return parsedCookie
}
