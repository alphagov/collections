//= require govuk_publishing_components/vendor/polyfills/closest

window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  function CoronavirusLandingPage ($module) {
    this.module = $module
  }

  CoronavirusLandingPage.prototype.init = function () {
    // Confirm the user is on the coronavirus landing page
    if (this.checkOnLandingPage()) {
      this.globarBarSeen()
    }
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

  Modules.CoronavirusLandingPage = CoronavirusLandingPage
})(window.GOVUK.Modules)
