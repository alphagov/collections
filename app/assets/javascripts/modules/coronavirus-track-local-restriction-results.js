window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  function CoronavirusTrackLocalRestrictionResults () {}

  CoronavirusTrackLocalRestrictionResults.prototype.start = function (element) {
    this.addRiskLevelEvent(element[0])
  }

  CoronavirusTrackLocalRestrictionResults.prototype.addRiskLevelEvent = function (element) {
    var label = element.getAttribute('data-tracking-label')

    var options = {
      transport: "beacon",
      label: label
    }

    GOVUK.analytics.trackEvent("postcodeSearch:local_lockdown", "postcodeResultShown", options)
  }

  Modules.CoronavirusTrackLocalRestrictionResults = CoronavirusTrackLocalRestrictionResults
})(window.GOVUK.Modules)
