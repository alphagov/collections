describe('Coronavirus local restriction results page', function () {
  "use strict"

  var coronavirusTrackLocalRestrictionResults;
  var html = '<div id="element" data-module="coronavirus-track-local-restriction-results" data-tracking-label="Tier One: London"></div>'
  var element

  beforeEach(function () {
    GOVUK.analytics = {
      trackEvent: function () {
      }
    }
    spyOn(GOVUK.analytics, 'trackEvent')

    element = document.createElement('div');
    element.innerHTML = html;
    element = element.firstElementChild

    coronavirusTrackLocalRestrictionResults = new GOVUK.Modules.CoronavirusTrackLocalRestrictionResults()
    coronavirusTrackLocalRestrictionResults.start([element])
  })

  afterEach(function () {
    GOVUK.analytics.trackEvent.calls.reset()
  })

  it("sends event on load", function () {
    expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith(
      "postcodeSearch:local_lockdown", "postcodeResultShown", {
        transport: "beacon",
        label: "Tier One: London"
      }
    )
  })
});
