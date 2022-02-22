describe('Coronavirus landing page', function () {
  'use strict'

  var coronavirusLandingPage
  var html =
    '<div id="element" data-module="coronavirus-landing-page">' +
      '<div class="gem-c-accordion" data-module="gem-accordion">' +
        '<div class="govuk-accordion__controls">' +
          '<button type="button" class="govuk-accordion__open-all" aria-expanded="false">' +
            'Open all<span class="govuk-visually-hidden"> sections</span>' +
          '</button>' +
        '</div>' +
        '<div class="govuk-accordion__section">' +
          '<div class="govuk-accordion__section-header">' +
            '<h3 class="govuk-accordion__section-heading">' +
              '<button type="button">How to protect yourself and others</button><span class="govuk-accordion__icon" aria-hidden="true"></span>' +
            '</h3>' +
          '</div>' +
          '<div class="govuk-accordion__section-content">accordion content</div>' +
        '</div>' +
      '</div>' +
    '</div>'
  var $element

  beforeEach(function () {
    $element = $(html)
    coronavirusLandingPage = new GOVUK.Modules.CoronavirusLandingPage($element[0])
    GOVUK.approveAllCookieTypes()
  })

  it('sets global_bar_seen to automatically hide if on /coronavirus', function () {
    GOVUK.cookie('global_bar_seen', JSON.stringify({ count: 0, version: 1 }))
    spyOn(coronavirusLandingPage, 'checkOnLandingPage').and.returnValue(true)
    coronavirusLandingPage.init()

    expect(parseCookie(GOVUK.cookie('global_bar_seen')).count).toBe(999)
  })

  it('only sets global_bar_seen if on /coronavirus', function () {
    GOVUK.cookie('global_bar_seen', JSON.stringify({ count: 0, version: 1 }))
    spyOn(coronavirusLandingPage, 'checkOnLandingPage').and.returnValue(false)
    coronavirusLandingPage.init()

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
      $element.find('.govuk-accordion__open-all').on('click', function (e) {
        var expanded = $(e.target).attr('aria-expanded') === 'true'
        $(e.target).attr('aria-expanded', expanded ? 'false' : 'true')
      })

      coronavirusLandingPage.init()
    })

    it('tracks expanding', function () {
      var $openCloseAllButton = $element.find('.govuk-accordion__open-all')

      expect($openCloseAllButton).toExist()
      expect($openCloseAllButton.attr('aria-expanded')).toBe('false')
      $openCloseAllButton.trigger('click')

      expect($openCloseAllButton.attr('aria-expanded')).toBe('true')
      expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith(
        'pageElementInteraction', 'accordionOpened', { transport: 'beacon', label: 'Expand all' }
      )
    })

    it('tracks collapsing', function () {
      var $openCloseAllButton = $element.find('.govuk-accordion__open-all')
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
    beforeEach(function () {
      var nationPickerHtml =
        '<div>' +
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
      $element = $(nationPickerHtml)
      $('body').append($element)
      coronavirusLandingPage = new GOVUK.Modules.CoronavirusLandingPage($element[0])
    })

    afterEach(function () {
      $element.remove()
    })

    it('show and hide appropriate sections of the page when the radio buttons change', function () {
      coronavirusLandingPage.init()

      var englandRadio = $element.find('#radio-0')
      var northernIrelandRadio = $element.find('#radio-1')
      var englandSection = $element.find('#nation-england')
      var northernIrelandSection = $element.find('#nation-northern_ireland')

      expect(englandSection).toBeVisible()
      expect(northernIrelandSection).toBeHidden()

      northernIrelandRadio.prop('checked', true)
      window.GOVUK.triggerEvent(northernIrelandRadio[0], 'change')
      expect(englandSection).toBeHidden()
      expect(northernIrelandSection).toBeVisible()

      englandRadio.prop('checked', true)
      window.GOVUK.triggerEvent(englandRadio[0], 'change')

      expect(englandSection).toBeVisible()
      expect(northernIrelandSection).toBeHidden()
    })

    it('can initialise to a non England country when they are initially selected', function () {
      var northernIrelandRadio = $element.find('#radio-1')
      var englandSection = $element.find('#nation-england')
      var northernIrelandSection = $element.find('#nation-northern_ireland')

      northernIrelandRadio.prop('checked', true)

      coronavirusLandingPage.init()

      expect(englandSection).toBeHidden()
      expect(northernIrelandSection).toBeVisible()
    })

    it('can cope with a browser, such as Chrome, that restores form fields late', function () {
      var northernIrelandRadio = $element.find('#radio-1')
      var englandSection = $element.find('#nation-england')
      var northernIrelandSection = $element.find('#nation-northern_ireland')

      coronavirusLandingPage.init()

      expect(englandSection).toBeVisible()
      expect(northernIrelandSection).toBeHidden()

      northernIrelandRadio.prop('checked', true)
      window.GOVUK.triggerEvent(window, 'pageshow')

      expect(englandSection).toBeHidden()
      expect(northernIrelandSection).toBeVisible()
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
