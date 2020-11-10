describe('Coronavirus landing page', function () {
  'use strict'

  var coronavirusLandingPage
  /* eslint-disable no-multi-str */
  var html = '\
  <div id="element" data-module="coronavirus-landing-page">\
    <div class="gem-c-accordion govuk-accordion" data-module="govuk-accordion">\
      <div class="govuk-accordion__controls">\
        <button type="button" class="govuk-accordion__open-all" aria-expanded="false">\
          Open all<span class="govuk-visually-hidden"> sections</span>\
        </button>\
      </div>\
      <div class="govuk-accordion__section">\
        <div class="govuk-accordion__section-header">\
          <h3 class="govuk-accordion__section-heading">\
            <button type="button">How to protect yourself and others</button><span class="govuk-accordion__icon" aria-hidden="true"></span>\
          </h3>\
        </div>\
        <div class="govuk-accordion__section-content">\
          accordion content\
        </div> \
      </div> \
    </div>\
  </div>'
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

      // similate govuk-accordion module
      $element.find('.govuk-accordion__open-all').on('click', function (e) {
        var expanded = $(e.target).attr('aria-expanded') === 'true'
        $(e.target).attr('aria-expanded', expanded ? 'false' : 'true')
      })

      coronavirusLandingPage.start($element)
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
})

function parseCookie (cookie) {
  var parsedCookie = JSON.parse(cookie)

  // Tests seem to run differently on CI, and require an extra parse
  if (typeof parsedCookie !== 'object') {
    parsedCookie = JSON.parse(parsedCookie)
  }

  return parsedCookie
}
