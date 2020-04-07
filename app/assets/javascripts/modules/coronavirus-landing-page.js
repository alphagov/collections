window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  function CoronavirusLandingPage () {}

  CoronavirusLandingPage.prototype.start = function ($element) {
    // Confirm the user is on the coronavirus landing page
    if (this.checkOnLandingPage()) {
      this.globarBarSeen()
    }
    this.addAccordionOpenAllTracking($element)
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
    $element.find('.govuk-accordion__open-all').on('click', function(e) {
      var expanded = $(e.target).attr('aria-expanded') == 'true'
      var label = expanded ?  'Collapse all' : 'Expand all'
      var action = expanded ?  'accordionClosed' : 'accordionOpened'
      var options = { transport: 'beacon', label: label }

      GOVUK.analytics.trackEvent('pageElementInteraction', action, options)
    })
  }

  Modules.CoronavirusLandingPage = CoronavirusLandingPage
})(window.GOVUK.Modules)
