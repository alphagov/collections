window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  function CoronavirusTrackLocalRestrictions () {}

  CoronavirusTrackLocalRestrictions.prototype.start = function (element) {
    this.addPostcodeFormSubmitListener(element[0])
    this.addErrorMessageEvent(element[0])
  }

  CoronavirusTrackLocalRestrictions.prototype.addPostcodeFormSubmitListener = function (element) {
    element.querySelector('.coronavirus-local-restrictions__postcode-form')
      .addEventListener('submit', function(event){
        var options = {
          transport: "beacon"
        }

        GOVUK.analytics.trackEvent("postcodeSearch:local_lockdown", "postcodeSearchStarted", options)
      })
  }

  CoronavirusTrackLocalRestrictions.prototype.addErrorMessageEvent = function (element) {
    var errorMessage = element.querySelector('[data-tracking=local-restrictions-postcode-error]')

    if (errorMessage) {
      var errorCode = errorMessage.getAttribute('data-error-code')
      var options = {
        transport: "beacon",
        label: errorMessage.textContent.trim()
      }

      GOVUK.analytics.trackEvent("userAlerts:local_lockdown", "postcodeErrorShown: " + errorCode, options)
    }
  }

  Modules.CoronavirusTrackLocalRestrictions = CoronavirusTrackLocalRestrictions
})(window.GOVUK.Modules)
