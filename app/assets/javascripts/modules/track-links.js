window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  'use strict'

  Modules.TrackLinks = function (element) {
    this.category = element.getAttribute('data-track-category')
    this.action = element.getAttribute('data-track-action')
    this.links = element.getElementsByTagName('a')
  }

  Modules.TrackLinks.prototype.init = function () {
    if (!this.category) return

    for (var i = 0; i < this.links.length; i++) {
      var link = this.links[i]
      link.addEventListener('click', function (e) {
        var options = {
          transport: 'beacon',
          label: e.target.getAttribute('href')
        }
        if (!this.action) this.action = e.target.innerText

        GOVUK.analytics.trackEvent(this.category, this.action, options)
      }.bind(this))
    }
  }
})(window.GOVUK.Modules)
