GOVUK.analytics = GOVUK.analytics || {}
GOVUK.analytics.trackEvent = function () {}

describe('Track timeline links', function () {
  'use strict'

  var html = '<div class="covid-timeline" data-module="track-timeline-links"> \
    <h2 class="gem-c-heading gem-c-heading--font-size-27 gem-c-heading--padding   govuk-!-margin-bottom-4">Recent and upcoming changes</h2> \
    <div class="covid-timeline__item"> \
      <h3 class="covid-timeline__item-heading govuk-heading-s">24 September</h3> \
      <div class="gem-c-govspeak govuk-govspeak " data-module="govspeak"> \
        <p>Get the <a rel="external" href="https://covid19.nhs.uk/">NHS COVID-19 app</a> to help protect yourself and others</p> \
      </div> \
    </div> \
      <div class="covid-timeline__item"> \
        <h3 class="covid-timeline__item-heading govuk-heading-s">24 September</h3> \
        <div class="gem-c-govspeak govuk-govspeak " data-module="govspeak"> \
        <p>Find out how the <a href="/government/news/chancellor-outlines-winter-economy-plan">Winter Economy Plan</a> will protect jobs and support businesses</p> \
      </div> \
    </div> \
  </div>'

  var element

  beforeEach(function () {
    GOVUK.analytics = {
      trackEvent: function () {
      }
    }
    spyOn(GOVUK.analytics, 'trackEvent')

    element = document.createElement('div')
    element.innerHTML = html
    element = element.firstElementChild

    var tracker = new GOVUK.Modules.TrackTimelineLinks()
    tracker.start([element])
  })

  afterEach(function () {
    GOVUK.analytics.trackEvent.calls.reset()
  })

  it('track events sends href as label', function () {
    element.querySelector('a[href="/government/news/chancellor-outlines-winter-economy-plan"]').dispatchEvent(new Event('click'))

    expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith(
      'pageElementInteraction', 'Timeline', {
        transport: 'beacon',
        label: '/government/news/chancellor-outlines-winter-economy-plan'
      }
    )
  })

  it('track events sends external href', function () {
    element.querySelector('a[href="https://covid19.nhs.uk/"]').dispatchEvent(new Event('click'))

    expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith(
      'pageElementInteraction', 'Timeline', {
        transport: 'beacon',
        label: 'https://covid19.nhs.uk/'
      }
    )
  })
})
