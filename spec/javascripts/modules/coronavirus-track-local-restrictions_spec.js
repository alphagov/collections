describe('Coronavirus local restrictions landing page', function () {
  'use strict'

  var coronavirusTrackLocalRestrictions
  var element

  describe('landing page without errors', function () {
    var html =
      '<div data-module="coronavirus-track-local-restrictions">' +
        '<form class="coronavirus-local-restrictions__postcode-form"></form>' +
      '</div>'

    beforeEach(function () {
      GOVUK.analytics = {
        trackEvent: function () {
        }
      }
      spyOn(GOVUK.analytics, 'trackEvent')

      element = document.createElement('div')
      element.innerHTML = html
      element = element.firstElementChild

      coronavirusTrackLocalRestrictions = new GOVUK.Modules.CoronavirusTrackLocalRestrictions()
      coronavirusTrackLocalRestrictions.start([element])
    })

    afterEach(function () {
      GOVUK.analytics.trackEvent.calls.reset()
    })

    it('track submit event', function () {
      element.querySelector('form').dispatchEvent(new Event('submit'))

      expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith(
        'postcodeSearch:local_lockdown', 'postcodeSearchStarted', { transport: 'beacon' }
      )
    })
  })

  describe('landing page with errors', function () {
    var html =
      '<div data-module="coronavirus-track-local-restrictions">' +
        '<div class="gem-c-error-summary govuk-error-summary" data-module="govuk-error-summary">' +
          '<h2 class="govuk-error-summary__title">There is a problem</h2>' +
          '<div class="govuk-error-summary__body">' +
            '<ul class="govuk-list govuk-error-summary__list">' +
              '<li class="gem-c-error-summary__list-item" data-tracking="local-restrictions-postcode-error" data-error-code="invalidPostcodeFormat"><a href="#postcodeLookup">Enter a postcode</a></li>' +
            '</ul>' +
          '</div>' +
        '</div>' +
        '<form class="coronavirus-local-restrictions__postcode-form"></form>' +
      '</div>'

    beforeEach(function () {
      GOVUK.analytics = {
        trackEvent: function () {
        }
      }
      spyOn(GOVUK.analytics, 'trackEvent')

      element = document.createElement('div')
      element.innerHTML = html
      element = element.firstElementChild

      coronavirusTrackLocalRestrictions = new GOVUK.Modules.CoronavirusTrackLocalRestrictions()
      coronavirusTrackLocalRestrictions.start([element])
    })

    afterEach(function () {
      GOVUK.analytics.trackEvent.calls.reset()
    })

    it('track error event', function () {
      expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith(
        'userAlerts:local_lockdown', 'postcodeErrorShown: invalidPostcodeFormat', { transport: 'beacon', label: 'Enter a postcode' }
      )
    })
  })
})
