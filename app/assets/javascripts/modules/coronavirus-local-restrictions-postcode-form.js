window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  function CoronavirusLocalRestrictionsPostcodeForm () {}

  CoronavirusLocalRestrictionsPostcodeForm.prototype.start = function ($element) {
    var element = $element[0] // access dom element from jQuery
    this.trackErrors(element)

    element.addEventListener('submit', this.submitHandler.bind(this))
  }

  CoronavirusLocalRestrictionsPostcodeForm.prototype.trackErrors = function (element) {
    var errorCode = element.getAttribute('data-error-code')
    var errorMessage = element.getAttribute('data-error-message')

    if (!errorCode || !errorMessage) { return }

    GOVUK.analytics.trackEvent(
      'userAlerts:local_lockdown',
      'postcodeErrorShown: ' + errorCode,
      { transport: 'beacon', label: errorMessage }
    )
  }

  CoronavirusLocalRestrictionsPostcodeForm.prototype.submitHandler = function (event) {
    var input = event.target.querySelector('input[name=postcode]')
    if (!input) { return }

    input.value = this.normalisePostcode(input.value)

    GOVUK.analytics.trackEvent(
      'postcodeSearch:local_lockdown',
      'postcodeSearchStarted',
      { transport: 'beacon' }
    )
  }

  CoronavirusLocalRestrictionsPostcodeForm.prototype.normalisePostcode = function (postcode) {
    var regex = /^\s*([A-Z]{1,2}[0-9][A-Z0-9]?)\s*([0-9][A-Z]{2})\s*$/i
    var match = postcode.match(regex)

    if (match) {
      return match[1].toUpperCase() + ' ' + match[2].toUpperCase()
    } else {
      return postcode
    }
  }

  Modules.CoronavirusLocalRestrictionsPostcodeForm = CoronavirusLocalRestrictionsPostcodeForm
})(window.GOVUK.Modules)
