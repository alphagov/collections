//= require govuk_publishing_components/vendor/polyfills/closest

window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  function CoronavirusLandingPage ($module) {
    this.module = $module
    this.init()
  }

  CoronavirusLandingPage.prototype.init = function () {
    // Confirm the user is on the coronavirus landing page
    if (this.checkOnLandingPage()) {
      this.globarBarSeen()
    }

    this.addAccordionOpenAllTracking()
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

  // we want to track the accordion show/hide all control but this is added dynamically
  // after page load by the accordion component, so we attach the event listener to the
  // accordion parent element then filter click events to only track that control
  CoronavirusLandingPage.prototype.addAccordionOpenAllTracking = function () {
    var accordions = this.module.querySelectorAll('.gem-c-accordion')
    for (var i = 0; i < accordions.length; i++) {
      accordions[i].addEventListener('click', function (e) {
        var clicked = e.target.closest('button')
        if (clicked && clicked.classList.contains('gem-c-accordion__open-all')) {
          var expanded = clicked.getAttribute('aria-expanded') === 'true'
          var label = expanded ? 'Expand all' : 'Collapse all'
          var action = expanded ? 'accordionOpened' : 'accordionClosed'
          var options = { transport: 'beacon', label: label }

          GOVUK.analytics.trackEvent('pageElementInteraction', action, options)
        }
      })
    }
  }

  Modules.CoronavirusLandingPage = CoronavirusLandingPage
})(window.GOVUK.Modules)
