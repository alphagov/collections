window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  function CoronavirusLandingPage () {}

  CoronavirusLandingPage.prototype.start = function ($element) {
    var $this = this
    // Confirm the user is on the coronavirus landing page
    if (this.checkOnLandingPage()) {
      this.globarBarSeen()
    }

    // Ensure that the "Open/Close all" element exists when attaching the event listeners for tracking
    $(document).ready(function () {
      $this.addAccordionOpenAllTracking($element)
    })
  }

  CoronavirusLandingPage.prototype.checkOnLandingPage = function () {
    return window.location.pathname === '/coronavirus'
  }

  CoronavirusLandingPage.prototype.globarBarSeen = function () {
    if (window.GOVUK.cookie('global_bar_seen')) {
      // Get current version of global bar, if cookie has been set
      var currentBannerVersion = JSON.parse(window.GOVUK.cookie('global_bar_seen')).version

      // Automatically hide the additional information section in the banner by setting the cookie
      window.GOVUK.setCookie('global_bar_seen', JSON.stringify({ count: 999, version: currentBannerVersion }), { days: 84 })
    }
  }

  CoronavirusLandingPage.prototype.addAccordionOpenAllTracking = function ($element) {
    $element.find('.govuk-accordion__open-all').on('click', function (e) {
      var expanded = $(e.target).attr('aria-expanded') == 'true'
      var label = expanded ? 'Expand all' : 'Collapse all'
      var action = expanded ? 'accordionOpened' : 'accordionClosed'
      var options = { transport: 'beacon', label: label }

      GOVUK.analytics.trackEvent('pageElementInteraction', action, options)
    })
  }

  Modules.CoronavirusLandingPage = CoronavirusLandingPage
})(window.GOVUK.Modules)
