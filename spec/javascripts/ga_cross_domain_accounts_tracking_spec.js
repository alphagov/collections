/* eslint-env jasmine, jquery */

describe('attachCrossDomainTrackerToLink', function () {
  var link
  var tracker
  var linker
  var GOVUK = window.GOVUK || {}

  beforeEach(function () {
    link = $('<a href="/somewhere" data-account-cross-domain="yes">')

    window.ga = {
      getAll: function () {}
    }

    window.gaplugins = {
      Linker: function () {}
    }

    linker = {
      decorate: function () {}
    }

    spyOn(window.ga, 'getAll').and.returnValue([])
    spyOn(window.gaplugins, 'Linker').and.returnValue(linker)
    spyOn(linker, 'decorate').and.returnValue('/somewhere?_ga=abc123')
  })

  afterEach(function () {
    link.remove()
  })

  it('leaves the link href unchanged if ga is not present', function () {
    tracker = []
    GOVUK.attachCrossDomainTrackerToLink(link, tracker)
    expect(link.attr('href')).toEqual('/somewhere')
  })

  it('leaves the link href if unchanged there are no trackers in ga', function () {
    tracker = []
    GOVUK.attachCrossDomainTrackerToLink(link, tracker)
    expect(link.attr('href')).toEqual('/somewhere')
  })

  it('modifies the link href to append ids from ga to the destination url', function () {
    tracker = [{ ga_mock: 'foobar' }]
    GOVUK.attachCrossDomainTrackerToLink(link, tracker)
    expect(link.attr('href')).toEqual('/somewhere?_ga=abc123')
  })
})
