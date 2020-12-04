/* eslint-env jquery */
/* global ga */

function attachCrossDomainTrackerToLink (link, trackers) {
  if (trackers.length) {
    var existingHref = link.attr('href')
    var linker = new window.gaplugins.Linker(trackers[0])
    var trackedHref = linker.decorate(existingHref)
    link.attr('href', trackedHref)
  }
}

window.GOVUK = window.GOVUK || {}
var GOVUK = window.GOVUK
GOVUK.attachCrossDomainTrackerToLink = attachCrossDomainTrackerToLink

$(window).on('load', function () {
  if (window.ga !== undefined && typeof window.ga.getAll === 'function') {
    var trackers = ga.getAll()

    var links = $('href[data-account-cross-domain="yes"]')
    links.each(function (link) {
      window.GOVUK.attachCrossDomainTrackerToLink(link, trackers)
    })
  }
})
