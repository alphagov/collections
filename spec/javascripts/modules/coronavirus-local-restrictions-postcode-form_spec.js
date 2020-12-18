describe('CoronavirusLocalRestrictionsPostcodeForm', function () {
  'use strict'

  var form, input, button, container, module

  beforeEach(function () {
    GOVUK.analytics = { trackEvent: function () {} }
    spyOn(GOVUK.analytics, 'trackEvent')

    container = document.createElement('div')
    container.innerHTML =
      '<form data-module="coronavirus-local-restrictions-postcode-form">' +
        '<input name="postcode">' +
        '<button type="submit">Submit</button>' +
      '</form>'
    document.body.appendChild(container)

    form = container.querySelector('form')
    form.addEventListener('submit', function (e) {
      e.preventDefault()
    })

    input = form.querySelector('input')
    button = form.querySelector('button')

    module = new GOVUK.Modules.CoronavirusLocalRestrictionsPostcodeForm()
  })

  afterEach(function () {
    document.body.removeChild(container)
    GOVUK.analytics.trackEvent.calls.reset()
  })

  describe('initialisation', function () {
    it('tracks a Google Analytics event when there are error attributes', function () {
      form.setAttribute('data-error-code', 'errorCode')
      form.setAttribute('data-error-message', 'This is an error')
      module.start($(form))
      expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith(
        'userAlerts:local_lockdown',
        'postcodeErrorShown: errorCode',
        { transport: 'beacon', label: 'This is an error' }
      )
    })

    it('doesn\'t track a Google Analytics event when there aren\'t error attributes', function () {
      module.start($(form))
      expect(GOVUK.analytics.trackEvent).not.toHaveBeenCalledWith()
    })
  })

  describe('submit handler', function () {
    beforeEach(function () {
      module.start($(form))
    })

    it('uppercases and spaces a valid looking postcode', function () {
      input.value = ' sw1a2aa '
      button.click()
      expect(input.value).toBe('SW1A 2AA')
    })

    it('doesn\'t change an invalid looking postcode', function () {
      var postcode = '677adsf12312'
      input.value = postcode
      button.click()
      expect(input.value).toBe(postcode)
    })

    it('doesn\'t change an uncommon postcode format', function () {
      var postcode = 'gir 0aa'
      input.value = postcode
      button.click()
      expect(input.value).toBe(postcode)
    })

    it('doesn\'t change an uncommon postcode format', function () {
      var postcode = 'gir 0aa'
      input.value = postcode
      button.click()
      expect(input.value).toBe(postcode)
    })

    it('tracks an event with Google Analytics', function () {
      button.click()
      expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith(
        'postcodeSearch:local_lockdown',
        'postcodeSearchStarted',
        { transport: 'beacon' }
      )
    })
  })
})
